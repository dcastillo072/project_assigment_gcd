#Preparation for the  project
library(data.table)
library(dplyr)

file_name <- "getdata_projectfiles_UCI HAR Dataset"

#checking file in my direcroty of working
if (!file.exists(file_name)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, file_name)
}

#check folder exist
if (!file.exists("UCI HAR Dataset")) { 
  unzip(file_name) 
}


#reading dataframes
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

#step 1 - merge the training set and te test sets to create one data set
x1 <- rbind(x_train, x_test)
y1 <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
Data_Merged <- cbind(subject, y1, x1)

#set 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
TidyData <- select(Data_Merged,subject,code,contains("mean"),contains("std"))

#step 3 
TidyData$code <- activities[TidyData$code, 2]



#Step 4: Appropriately labels the data set with descriptive variable names.

names(TidyData)[2] = "activity"
names(TidyData)<-gsub("Acc", "Accelerometer", names(TidyData))
names(TidyData)<-gsub("Gyro", "Gyroscope", names(TidyData))
names(TidyData)<-gsub("BodyBody", "Body", names(TidyData))
names(TidyData)<-gsub("Mag", "Magnitude", names(TidyData))
names(TidyData)<-gsub("^t", "Time", names(TidyData))
names(TidyData)<-gsub("^f", "Frequency", names(TidyData))
names(TidyData)<-gsub("tBody", "TimeBody", names(TidyData))
names(TidyData)<-gsub("-mean()", "Mean", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-std()", "STD", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("-freq()", "Frequency", names(TidyData), ignore.case = TRUE)
names(TidyData)<-gsub("angle", "Angle", names(TidyData))
names(TidyData)<-gsub("gravity", "Gravity", names(TidyData))


#setp 5 From the data set in step 4, creates a second, independent tidy data set with the average 
#of each variable for each activity and each subject.
#Final_Data<-group_by(TidyData,subject,activity)
#Final_Data<-summarise_all(TidyData,mean)

FinalData <- TidyData %>%
  group_by(subject, activity) %>%
  summarise_all(funs(mean))
write.table(FinalData, "FinalData.txt", row.name=FALSE)
