% A
% Step #1
% Load the csv files after pointing to the correct directory
data   = 'data_6months.csv'; %change and put the other dataset in this area
config = 'config.csv';

% Step #2
% We need to read the data file here
datatbl = readtable(data);

% Step #3
% We can check here if the columns are read correctly
if ~isdatetime(datatbl.date)                    % check if 'date' column is not a datetime
    datatbl.date = datetime(datatbl.date);      % convert 'date' column to datetime type
end

% Step #4
% Put columns of data into set variables, makes it easier to call
x = datatbl.date;    % For plotting purposes (x-axis)
y = datatbl.value;   % For plotting purposes (y-axis)

% Step #5
% Read the config file and turn it into a struct
cfgTbl = readtable(config, 'TextType','string');  % read config file as strings
cfg = struct();                                   % create an empty structure for settings
for i = 1:height(cfgTbl)                          % loop through each row in config file
    k = strtrim(cfgTbl.key(i));                   % read key name 
    v = strtrim(cfgTbl.value(i));                 % read key value 
    cfg.(k) = v;                                  % store key and value in the structure
end

% Step #6
% Read options from config with defaults
if isfield(cfg,'showMeanLine')
    showMean = (cfg.showMeanLine == "1");         % true if "1", false otherwise
else
    showMean = false;                             % default: don't show mean line
end

if isfield(cfg,'showTrendLine')
    showTrend = (cfg.showTrendLine == "1");       % true if "1"
else
    showTrend = false;                            % default: don't show trend line
end

if isfield(cfg,'trendType')
    trendType = lower(cfg.trendType);             % read and make lowercase
else
    trendType = "linear";                         % default trend type is linear
end

if isfield(cfg,'xlabel')
    xLbl = cfg.xlabel;                            % use that text
else
    xLbl = "Date";                                % default x-axis label
end

if isfield(cfg,'ylabel')
    yLbl = cfg.ylabel;                            % use that text
else
    yLbl = "Value";                               % default y-axis label
end

% 🔹 Step #6.5 – use Part C to get the trend (this calls your function below)
if showTrend
    if trendType == "linear"
        yTrend = dataTrend(x, y, 'linear');             % linear trend
    elseif trendType == "poly3"
        yTrend = dataTrend(x, y, 'poly3');              % 3rd order poly trend
    elseif trendType == "hp"
        yTrend = dataTrend(x, y, 'hp', 100000);         % HP filter trend (stronger smoothing)
    else
        yTrend = [];
    end
else
    yTrend = [];
end

% Step #7
% Make the plot (visible so it pops up)
f = figure('Visible','on');                       % create visible figure window
plot(x, y, '-o', 'DisplayName','Data');           % plot data points as a line with circles
hold on;                                          % keep plot open for more lines
grid on;                                          % show grid on background

% Add mean line if enabled
if showMean
    m = mean(y,'omitnan');                        % calculate the mean of all values
    plot([min(x) max(x)], [m m], '--r', ...
        'LineWidth',1.2, 'DisplayName','Mean');   % draw red mean line
end

% Add trend line if we computed one
if showTrend && ~isempty(yTrend)
    plot(x, yTrend, '--g', 'LineWidth',1.2, ...
        'DisplayName','Trend');                   % draw green trend line
end

% Step #8
% Labels, title, legend
xlabel(xLbl);                                     % X-axis label
ylabel(yLbl);                                     % Y-axis label
title(yLbl + " vs " + xLbl);                      % Title uses both labels (e.g., "Value vs Date")
legend('show','Location','best');                 % show legend for lines on the plot
saveas(f, 'plot.png');                            % save figure as a PNG file



% C 
% (Matlab jumps here to call the function, datatrend)
function yTrend = dataTrend(x, y, trendType, lambda)
% Returns a trend line based on the selected trendType

    y = y(:);                                      % force column

    if isdatetime(x)
        xNum = datenum(x);                         % convert dates to numeric
    else
        xNum = x(:);
    end

    switch lower(trendType)
        case 'linear'
            p = polyfit(xNum, y, 1);               % linear regression
            yTrend = polyval(p, xNum);             % evaluate line

        case 'poly3'
            p = polyfit(xNum, y, 3);               % 3rd-order polynomial regression
            yTrend = polyval(p, xNum);             % evaluate curve

        case 'hp'
            if nargin < 4 || isempty(lambda)
                lambda = 100000;                   % stronger default smoothing
            end
            yTrend = hpFilter(y, lambda);          % call helper HP filter below

        otherwise
            warning('Unknown trendType "%s". Returning empty.', trendType);
            yTrend = [];
    end
end

% helper function for HP filter
function yTrend = hpFilter(y, lambda)
    T = length(y);                                % number of points
    I = speye(T);                                 % identity matrix
    e = ones(T,1);                                % helper vector
    D = spdiags([e -2*e e], 0:2, T-2, T);         % 2nd difference matrix
    A = I + lambda * (D' * D);                    % HP filter equation
    yTrend = A \ y;                               % solve for trend
end
