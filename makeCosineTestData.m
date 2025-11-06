function makeCosineTestData(filename)
% makeCosineTestData
% Generates 50 daily values for a cosine function with:
% amplitude = 1, period = 60 days, plus random noise (σ = 1)

    nPoints   = 50;                                   % number of data points
    days      = (0:nPoints-1)';                       % sequence of day numbers (0–49)
    amplitude = 1;                                    % cosine amplitude
    period    = 60;                                   % 60-day period
    noiseStd  = 1;                                    % standard deviation of noise

    y = amplitude * cos(2*pi*days/period);            % pure cosine signal
    y = y + noiseStd * randn(nPoints,1);              % add Gaussian noise (mean 0, σ = 1)

    startDate = datetime('today');                    % starting date (today)
    dateCol   = startDate + days;                     % create date vector
    T         = table(dateCol, y, ...                 % combine into a table
                      'VariableNames', {'date','value'});
    writetable(T, filename);                          % write the table to a CSV file
end