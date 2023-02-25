# Getting and Cleaning Data Course Project 

The run_analysis.R script performs the following steps:

## Step 1:

Extracts the test and training data (including feture names and activity labels) from the UCI HAR Dataset at the following location:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip  
 
Data is assigned to the following data sets:

### Test data sets
    subject_test
    X_test 
    y_test 

### Training data sets
    subject_train 
    X_train 
    y_train 

### Feature names
    feature_names 

### Activity Labels
    activity_labels

## Step 2

Data is merged to create a single dataset called 'test_train'

## Step 3

The dataset is reduced by extracting only the measurements on the mean and standard deviation for each. The 
new dataset is called 'test_train_reduce'

## Step 4

Labels for the variables are tidied and lengthed to add more detail, in additon to making more human readable. 
More information regarding the varible details can be found in README.

## Step 5

A second, reduced dataset is created with the average of each variable for each activity and each subject.
This dataset is named 'tidy_data'

## Step 6

The reduced dataset 'tidy_data' is saved to tidy_data.txt using write.table

