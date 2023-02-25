library(data.table)
library(dplyr)

################################################################################
# read data from 'Human' Activity Recognition Using Smartphones Data Set'
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 
################################################################################

# set working directory for files
setwd('C:/Users/Coursera/Coursera/Clean Tidy Data/
      getdata_projectfiles_UCI HAR Dataset (1)/UCI HAR Dataset')

# get test data sets
subject_test <- fread('test/subject_test.txt', header =FALSE)
X_test <- fread('test/X_test.txt', header =FALSE)
y_test <- fread('test/y_test.txt', header =FALSE)

# get training data sets
subject_train <- fread('train/subject_train.txt', header =FALSE)
X_train <- fread('train/X_train.txt', header =FALSE)
y_train <- fread('train/y_train.txt', header =FALSE)

# get feature names
feature_names <- fread('features.txt', header =FALSE)

# get activity names
activity_labels <- read.table('activity_labels.txt', header =FALSE)
colnames(activity_labels) <- c("Activity_Code", "Activity_Description")

################################################################################
# Merge the training and the test sets to create one data set
################################################################################

# merge test data with data and subject labels
test_all <- cbind(subject_test,y_test,X_test)

# merge training data with data and subject labels
train_all <- cbind(subject_train,y_train,X_train)

# stitch training and test data together
test_train <- rbind(test_all, train_all)

# assign column names
colnames(test_train) <-  c("Subject", "Activity", t(feature_names[,2]))



################################################################################
# Extract only the measurements on the mean and standard deviation for each
# measurement. 
################################################################################

# get column names with standard deviation and mean, creating new dataset by 
# removing all others
col_keep <- grep("Subject|Activity|mean|std",colnames(test_train), ignore.case=TRUE)
test_train_reduce <- test_train[,col_keep, with=FALSE]

################################################################################
# Uses descriptive activity names to name the activities in the data set
################################################################################

# assign descriptive activity labels from activity_labels.txt
test_train_reduce$Activity <- factor(test_train_reduce$Activity,
                                     levels = activity_labels$Activity_Code,
                                     labels = activity_labels$Activity_Description)

################################################################################
# Appropriately label the data set with descriptive variable names
################################################################################

test_train_reduce_cols <-  colnames(test_train_reduce)
test_train_reduce_cols <-  gsub("^f", "Frequency_Domain_", test_train_reduce_cols)
test_train_reduce_cols <-  gsub("^t", "Time_Domain_", test_train_reduce_cols)
test_train_reduce_cols <-  gsub("BodyBody", "Body", test_train_reduce_cols)
test_train_reduce_cols <-  gsub("Body", "Body_", test_train_reduce_cols)
test_train_reduce_cols <-  gsub("tBody", "Time_Domain_Body_", test_train_reduce_cols)
test_train_reduce_cols <-  gsub("Acc", "Acceleration_", test_train_reduce_cols)
test_train_reduce_cols <-  gsub("Gyro", "Gyroscope_", test_train_reduce_cols)
test_train_reduce_cols <-  gsub("Jerk", "Jerk_", test_train_reduce_cols)
test_train_reduce_cols <-  gsub("mean", "Mean_", test_train_reduce_cols, ignore.case = TRUE)
test_train_reduce_cols <-  gsub("std", "Standard_Deviation_", test_train_reduce_cols)
test_train_reduce_cols <-  gsub("X", "X_Axis_", test_train_reduce_cols)
test_train_reduce_cols <-  gsub("Y", "Y_Axis_", test_train_reduce_cols)
test_train_reduce_cols <-  gsub("Z", "Z_Axis_", test_train_reduce_cols)
test_train_reduce_cols <-  gsub("angle", "Vector_Angle_", test_train_reduce_cols)
test_train_reduce_cols <-  gsub("gravity", "Gravity_", test_train_reduce_cols)

# remove unnecessary characters
test_train_reduce_cols <-  gsub("[(]", "", test_train_reduce_cols)
test_train_reduce_cols <-  gsub("[)]", "", test_train_reduce_cols)
test_train_reduce_cols <-  gsub(",", "", test_train_reduce_cols)

# rename column names in reduced data set with the human readable column names
# from above
colnames(test_train_reduce) <- test_train_reduce_cols

################################################################################
# Create a second, independent tidy data set with the average of each variable 
# for each activity and each subject.
################################################################################

tidy_data <- test_train_reduce %>%
    group_by(Subject, Activity) %>%
    summarise(across(test_train_reduce_cols[-(1:2)],mean))


################################################################################
# Output data to .txt file
################################################################################

# output to file "Tidy_Data.txt"
write.table(tidy_data, "Tidy_Data.txt", row.names = FALSE, 
            quote = FALSE)