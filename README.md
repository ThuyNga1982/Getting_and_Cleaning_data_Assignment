This README.md file presents the description of each file in the
repository, and explains how the scripts works.

The repository includes the following files:
--------------------------------------------

1.  **README.md**: contains the content and the description of each file
    in the repository and explains how the scripts works.  
2.  **tidy\_data.txt**: the resulting tidy data that can be used for
    later analysis.
3.  **codebook.md**: the code book that describes the data, the
    processing steps and the explanation of the work performed to create
    the tidy data from the downloaded data.
4.  **run.analysis.R**: the main script file that does the following
    tasks:

-   Merge the training and the test sets to create one data set.  
-   Extract only the measurements on the mean and standard deviation for
    each measurement.
-   Use descriptive activity names to name the activities in the data
    set  
-   Appropriately label the data set with descriptive variable names.  
-   From the data set in step 4, create a second, independent tidy data
    set with the average of each variable for each activity and each
    subject.

How the script should be run:
-----------------------------

The **run.analysis.R** file should be able to run and perform the above
tasks without requiring the data being downloaded in a computer
beforehand because it includes the following ***“download and unzip”***
script at the beginning. You just need to open and ***“run”*** it.

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

The functions *“melt”* and *“dcast”* used in task 4 require the package
*“reshape2”*. The **run.analysis.R** file includes the following script
to check the presence of it. If the library *“reshape2”* is not already
installed, it will automatically install it and then load it. You do not
need to do anything.

    if (!library(reshape2, logical.return = TRUE)){
              install.packages("reshape2")
              library("reshape2")
          }

The resulting dataset **tidy\_data.txt** is a txt file and can be simply
opened by this command in R:

    tidy_data <- read.table("tidy_data.txt")
