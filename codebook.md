This Code book presents the information on the data, the description and
explanation of the steps to create the final tidy data. It also includes
the main variables along with units and other relevant information.

### Data overview

The data used in this assignment contains various measurements related
to people’s movements captured from 30 participants using smart phones
while they performed 6 different activities.

### The description of variables:

The data was download and read into the below data frames:

-   **X\_test**: a data frame (2947 rows x 561 columns) of integers,
    denoting the observations of the testing set.  
-   **X\_train**: a data frame (7352 rows x 561 columns) of integers,
    denoting the observations of the training set.  
-   **Y\_test**: a data frame (2947 rows x 1 columns) of intergers,
    denoting the ID of the activity corresponding to each observation in
    the testing set.  
-   **Y\_train**: a data frame (7352 rows x 1 columns) of intergers,
    denoting the ID of the activity corresponding to each observation in
    the training set.  
-   **subject\_test**: a data frame (2947 rows x 1 columns) of
    intergers, denoting the ID of the participant performing the
    activity corresponding to each observation in the testing set.  
-   **subject\_train**: a data frame (2947 rows x 1 columns) of
    intergers, denoting the ID of the participant performing the
    activity corresponding to each observation in the training set.  
-   **features**: a data frame (561 rows x 2 columns). The first column
    (V1) is the ordering number, the second column (V2) is a vector of
    characters, denoting the names of features.

### Processing steps and explanation

Creating an R script called run\_analysis.R that does the following:

#### 1. Merge the training and the testing sets to create one data set. \#\#\#\# Steps:

1.1 Read relevant datasets into data frames

    # Reading datasets
        Y_test <- read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
        X_test <- read.table(".\\UCI HAR Dataset\\test\\X_test.txt")
        X_train <- read.table(".\\UCI HAR Dataset\\test\\X_train.txt")
        Y_train <- read.table(".\\UCI HAR Dataset\\test\\y_train.txt")
        subject_train <- read.table(".\\UCI HAR Dataset\\test\\subject_train.txt")
        subject_test <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")
        features <- read.table(".\\UCI HAR Dataset\\features.txt")

1.2. Label variables

    names(subject_test) <- "subject_ID"
    names(subject_train) <- "subject_ID"
    names(Y_test) <- "activity"
    names(Y_train) <- "activity"
    names(X_test) <- features$V2
    names(X_train) <- features$V2

1.3. Merge the training and testing sets into one, resulting in a data
frame called **full\_data** which has 10299 rows and 563 columns.

    subject_XY_test <- cbind(subject_test,Y_test,X_test)
    subject_XY_train <- cbind(subject_train,Y_train,X_train)
    full_data <-rbind(subject_XY_test,subject_XY_train)

#### 2. Extract only the measurements on the mean and standard deviation for each measurement:

#### Steps:

2.1. Create a variable namely **mean\_std** and assign the value TRUE
corresponding to the columns of which the labels have “mean()” or
“std()” in the end and FALSE for the remaining columns

    mean_std <- grepl("mean\\(\\)",names(full_data)) | grepl("std\\(\\)",names(full_data))

2.2. Keep the first 2 columns (“subject\_ID” and “activity”) by
assigning TRUE to the first 2 elements of **mean\_std**

    mean_std[1:2] <- TRUE

2.3. Create a data frame, namely **data\_mean\_std** that has only the
measurements on the mean and std for each measurement from
**full\_data** by removing the columns that have corresponding
**mean\_std** equal to FALSE. This left 68 columns including
**subject\_ID** and **activity** columns.

    data_mean_std <- full_data[,mean_std]

#### 3. Use descriptive activity names to name the activities in the data set

Converting the column **activity** in data frame **data\_mean\_std**
from integer to factor, using the labels from **activity\_labels.txt**
file.

    activity_names <- c("WALKING","WALKING_UP","WALKING_DOWN","SITTING","STANDING","LAYING")
    data_mean_std$activity <- factor(data_mean_std$activity, labels = activity_names )

#### 4. Appropriately label the data set with descriptive variable names:

The subject\_test, subject\_train, Y\_test and Y\_train data frames have
the same variable names (V1). Labelling the names in the datasets should
be done before merging to avoid having the same column names in the
combined data.

#### 5. From the dataset in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.

    data_melted <- melt(data_mean_std, c("subject_ID", "activity"), variable)
    tidy_data <- dcast(data_melted,subject_ID + activity ~ variable, mean )

The final tidy data set contains the average of each variable for each
activity and each subject. Because there were 30 subjects and each
performed 6 activities, this data frame has 180 rows (each row is for
one subject performing one activity) and 68 columns (each column is the
average of each measurement corresponding to a subject performing an
activity and they are the columns with “mean()” or “std()” in the end of
the column names since it was extracted from **data\_mean\_std**). This
tidy data set is output to a txt file named **tidy\_data.txt** with the
command:

    write.table(tidy_data,file = "tidy_data.txt",row.name= FALSE)
