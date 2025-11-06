function makeTestData(filename, numDays, minVal, maxVal)
% makeTestData
% It creates a CSV file with two columns: date, value.

    startDate = datetime('today') - days(numDays - 1);   % find start date (numDays ago)
    dateCol   = startDate + days(0:numDays-1);           % generate a list of sequential dates
    valCol    = randi([minVal maxVal], numDays, 1);      % create random integer values in given range
    T         = table(dateCol', valCol, ...              % combine dates and values into a table
                     'VariableNames', {'date','value'}); 
    writetable(T, filename);                             % write the table to a CSV file
end