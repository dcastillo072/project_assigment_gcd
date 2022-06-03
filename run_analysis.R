#Preparation for the  project

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

