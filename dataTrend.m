function yTrend = dataTrend(x, y, trendType, lambda)
% C
% dataTrend
% Returns a trend line based on the selected trendType
% x         - time axis (can be datetime or numeric)
% y         - data values (column vector)
% trendType - 'linear', 'poly3', or 'hp'
% lambda    - smoothing parameter for HP filter (only used for 'hp')

    % make sure y is a column
    y = y(:);                                         % force column

    % if x is datetime, convert to numeric for regression
    if isdatetime(x)
        xNum = datenum(x);                            % convert dates to numbers
    else
        xNum = x(:);                                  % make sure it's a column
    end

    switch lower(trendType)

        case 'linear'
            % Linear Trend: y = a*x + b 
            p = polyfit(xNum, y, 1);                   % fit 1st-order poly
            yTrend = polyval(p, xNum);                 % evaluate line at x

        case 'poly3'
            % Polynomial Trend
            p = polyfit(xNum, y, 3);                   % fit 3rd-order poly
            yTrend = polyval(p, xNum);                 % evaluate cubic at x

        case 'hp'
            % Hodrick-Prescott Filter
            % yTrend = argmin (sum (y - yTrend)^2 + lambda * sum (Δ^2 yTrend)^2)
            % if user didn't give lambda, pick a default
            if nargin < 4 || isempty(lambda)
                lambda = 1600;                         % common macro default
            end
            yTrend = hpFilter(y, lambda);              % call helper below

        otherwise
            warning('Unknown trendType "%s". Returning empty.', trendType);
            yTrend = [];
    end
end


function yTrend = hpFilter(y, lambda)
% hpFilter
% Basic HP filter implementation for 1D series
% y      - data column
% lambda - smoothing parameter

    T = length(y);                                    % number of points

    % Identity matrix
    I = speye(T);                                     % sparse identity

    % Second-difference operator matrix (T-2 x T)
    e = ones(T,1);                                    % helper vector
    D = spdiags([e -2*e e], 0:2, T-2, T);             % builds 2nd diff matrix

    % HP system: (I + lambda * D'*D) * yTrend = y
    A = I + lambda * (D' * D);                        % system matrix
    yTrend = A \ y;                                   % solve for trend
end
