# MATLAB Interview Task (Mitek Analytics) -Artur Akopyan
# Project Description
MATLAB time series plotter with generated data and configurable trends - this project reads CSV datasets and config files to generate customixable plots with optimized mean lines, linear/ploy regressions, or Hodrick-Prescott filter trend smoothing. This code outputs a detailed labeled visualization (PNG) which shows the key data trends and patterns.

# Functionality Description
The main script is 'task.m'
1. Reads datasets(change dataset to whichever one you want) and config file
2. Checks data formats are good
3. Plots the data, mean/trend lines
4. saves the output as plot_x (x being what dataset you choose from the three datasets)

# Test Data Generator
The script is 'makeTestData.m'
1. This generates the test datasets ('data_6months.csv, 'data_31days.csv, 'data_365days')
   a. You need to change the code accordingly to generate what you want
2. Supports random data or cosine-based noisy data
3. Assists in verifying trend and smoothing functionality

# Data Trending Algorithm
The function is dataTrend.m (we have this called in 'task.m')
1. Linear regression, using least-squares fit
2. 3rd order poly regression
3. Hodrick-Prescott Filter for nonparametric trend smoothing (we can set our lambda = 100000 for better smooth results on the noisy cosine data)

# Output
A PNG image called 'plot.png' will be generated showing the visualization 

# User Instructions
Open MATLAB
1. Place these files in the same directory:
   - 'task.m'
   - `makeTestData.m'
   - 'dataTrend.m'
   -  make sure you have set the correctly directory for the data to be inputted into the folders
2. Edit the first lines of `task.m` to point to your data file:
   data   = for example 'data_365.csv';
   config = for example 'config.csv';
3. Run the script
4. Plot will show in window and save in the corrrect folder as 'plot.png', you can go ahead and rename the plot graph afterwards.

# Config File
The config.csv file defines how the plot should look:
  (key, value, comment)

  | **Key** | **Value Example** | **Description** |
|----------|------------------|-----------------|
| showMeanLine | 1 | Show (1) or hide (0) the red mean line |
| showTrendLine | 1 | Show (1) or hide (0) the green trend line |
| trendType | linear / poly3 / hp | Selects trend algorithm:<br>• **linear** – straight regression<br>• **poly3** – curved fit<br>• **hp** – smoothed trend |
| xlabel | Date | Text label for x-axis |
| ylabel | Value | Text label for y-axis |

# Data Interface Specs
  ## Data file (inputs)
  1. Format : .csv
  2. Columns :
     a. date = we check correct format in matlab
     b. value = numberical value
  
  ## Config file (inputs)
  1. Format : .csv
  2. Columns :
     a. key
     b. value
     c. comment
  3. Helps define which labels and lines to display on the plot
  
  ## Output
  1. Format : plot.png (.png)
  2. Description
     a. Blue Line = raw data
     b. Red Line = mean
     c. Green Line = trend
     d. Labels automatically applied

   
