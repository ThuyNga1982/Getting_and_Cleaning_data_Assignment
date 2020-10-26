# Download and unzip the data
 dirname = "UCI_Data"
 filename = "UCI_Data/zip_file.zip"
 fileurl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
 If (!file.exists(dirname)) {
   dir.create(dirname)
   if (!file.exists(filename))    
      download.file(fileurl,filename)
 }
setwd(dirname)
unzip("zip_file.zip")

#1. Merge the training and the testing sets to create one dataset.

    # Reading datasets
    Y_test <- read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
    X_test <- read.table(".\\UCI HAR Dataset\\test\\X_test.txt")
    X_train <- read.table(".\\UCI HAR Dataset\\train\\X_train.txt")
    Y_train <- read.table(".\\UCI HAR Dataset\\train\\y_train.txt")
    subject_train <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")
    subject_test <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")
    features <- read.table(".\\UCI HAR Dataset\\features.txt")
    
    # Label variables
    names(subject_test) <- "subject_ID"
    names(subject_train) <- "subject_ID"
    names(Y_test) <- "activity"
    names(Y_train) <- "activity"
    names(X_test) <- features$V2
    names(X_train) <- features$V2
    
    # Merge datasets into one:
    subject_XY_test <- cbind(subject_test,Y_test,X_test)
    subject_XY_train <- cbind(subject_train,Y_train,X_train)
    full_data <-rbind(subject_XY_test,subject_XY_train)

#2. Extract only the measurements on the mean and standard deviation for each measurement.
    
    # Find columns of which the labels contain contain "mean()" or "std()"
    mean_std <- grepl("mean\\(\\)",names(full_data)) | grepl("std\\(\\)",names(full_data))
    
    # Keep the first 2 columns ("subject_ID" and "activity")
    mean_std[1:2] <- TRUE
    
    # Create a dataset that has only the measurements on the mean and std for each measurement
    data_mean_std <- full_data[,mean_std]

# 3. Use descriptive activity names to name the activities in the data set
    
    activity_names <- c("WALKING","WALKING_UP","WALKING_DOWN","SITTING","STANDING","LAYING")
    data_mean_std$activity <- factor(data_mean_std$activity, labels = activity_names )

# 4. Appropriately label the data set with descriptive variable names.
    
      #This is done in the "Labels variables" step  before merging data sets to avoid 
      #having the same column names in the combined data.

#5. From the data set in step 4, create a second, independent tidy data set with the average of 
# each variable for each activity and each subject.
    # Check if the library "reshape2" is installed, if not install it and then load it.
      if (!library(reshape2, logical.return = TRUE)){
           install.packages("reshape2")
           library("reshape2")
       }
    data_melted <- melt(data_mean_std, c("subject_ID", "activity"))
    tidy_data <- dcast(data_melted,subject_ID + activity ~ variable, mean )

    # Write the tidy data into "tidy_data.txt"
    write.table(tidy_data,file = "tidy_data.txt",row.name= FALSE)
    