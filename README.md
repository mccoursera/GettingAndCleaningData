GettingAndCleaningData
======================

Project for Getting and Cleaning data course.

To get tidy data you have to run script run_analysis.R.
Before running script, you have to install packages 
"dplyr" and "reshape2" (install.packages("dplyr", "reshape2")).

Script will work with data available in working directory (getwd()/setwd()).
Script will generate tidy_data.txt output file.
Code is heavily commented, but here are the main steps of the script:
1. Loads train and test datasets and merges them together.
2. Fetches variables with regex "std() or mean()" on variable names.
3. Calculates from another source each activity label. 
   It doesn't add this column to the merged and filtered dataset yet.
4. Adds column names copied from another source file.
5. Adds two columns: subject and label to the dataset.
   After that it transforms it to long data set, calculates means, 
   creates names of mean columns as "Mean of ...", transforms back to wide data set
   and finally outputs tidy dataset to tidy_data.txt file.

Codebook (Codebook.txt) is available for detailed information about variables.



