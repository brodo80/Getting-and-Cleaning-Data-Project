##Download and Import Contents into R

url <- https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

> download.file(url,"C:/Users/brodo/Desktop/Cleaning data/Class 3/week 4/Project/data.zip")

unzip(zipfile="C:/Users/brodo/Desktop/Cleaning data/Class 3/week 4/Project/data.zip",exdir = "C:/Users/brodo/Desktop/Cleaning data/Class 3/week 4/Project")

unziplocation<- file.path("C:/Users/brodo/Desktop/Cleaning data/Class 3/week 4/Project","UCI HAR Dataset")
> file <- list.files(unziplocation)

subjecttest <- read.table("C:/Users/brodo/Desktop/Cleaning data/Class 3/week 4/Project/UCI HAR Dataset/test/subject_test.txt",header = FALSE)

subjectxtest <- read.table("C:/Users/brodo/Desktop/Cleaning data/Class 3/week 4/Project/UCI HAR Dataset/test/X_test.txt",header = FALSE)

subjectytest <- read.table("C:/Users/brodo/Desktop/Cleaning data/Class 3/week 4/Project/UCI HAR Dataset/test/Y_test.txt",header = FALSE)

subjecttrain <- read.table("C:/Users/brodo/Desktop/Cleaning data/Class 3/week 4/Project/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subjectxtrain <- read.table("C:/Users/brodo/Desktop/Cleaning data/Class 3/week 4/Project/UCI HAR Dataset/train/X_train.txt", header = FALSE)
subjectytrain <- read.table("C:/Users/brodo/Desktop/Cleaning data/Class 3/week 4/Project/UCI HAR Dataset/train/y_train.txt", header = FALSE)

##Merge data frames, import the features.txt file, reaname variables and append the variable descriptors for the combined data set

subject <- rbind(subjecttrain,subjecttest)
subjectx <- rbind(subjectxtrain,subjectxtest)
subjecty <- rbind(subjectytrain,subjectytest)
features <- read.table("C:/Users/brodo/Desktop/Cleaning data/Class 3/week 4/Project/UCI HAR Dataset/features.txt", header = FALSE)
names(subject)<-c("subject")
names(subjecty)<-c("Activity")
names(subjectx) <- features$V2
dataone <- cbind(subject,subjecty)
wholedata <- cbind(dataone,subjectx)

##subset data frame variables so that only Activity, Subject and mean and standard deviation based variables remain

class(features$V2)

variables <- as.character(features[,2])


class(variables)

subsetvar <- grep("mean[()]|std",variables,value = TRUE)

class(subsetvar)
?subset

columnselection <- c("subject", "Activity", subsetvar)

columnselection

wholeparsed <- subset(wholedata,select = columnselection)

str(wholeparsed)

##Import activity_labels.txt file and update the activity column from number to activity type

activity_labels <-read.table("C:/Users/brodo/Desktop/Cleaning data/Class 3/week 4/Project/UCI HAR Dataset/activity_labels.txt",header = FALSE)

colnames(activity_labels)[1] <- "Activity"

wholeparsed$Activity<-activity_labels[match(wholeparsed$Activity, activity_labels$Activity),2]

head(wholeparsed)

##Update the variable names so that they are more clear

names(wholeparsed) <-gsub("^t", "time", names(wholeparsed))
names(wholeparsed) <-gsub("^f", "frequency", names(wholeparsed))
names(wholeparsed) <-gsub("Acc", "Accelerometer", names(wholeparsed))
names(wholeparsed) <-gsub("Gyro", "Gyroscope", names(wholeparsed))
names(wholeparsed) <-gsub("Mag", "Magnitude", names(wholeparsed))
names(wholeparsed) <-gsub("BodyBody", "Body", names(wholeparsed))

Restructure data frame and export a tidy.txt file

library(plyr)

library(reshape2)

tidytest <- melt(wholeparsed,id=c("Activity","subject"))

tidytwo <- dcast(tidytest, Activity + subject ~ variable,mean)

head(tidytwo)

tail(tidytwo)

write.table(tidytwo, "//Txdf2fpw01cbtp/txcbt-redirected/smb001/Downloads/tidy.txt")

