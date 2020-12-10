library(dplyr)
setwd("~/Desktop/UCI HAR Dataset")
features<-read.table("features.txt",col.names = c(n,"functions"))
activities_labels<-read.table("activity_labels.txt",col.names = c("code","activity"))
subject_test <- read.table("test/subject_test.txt", col.names = "subject")
subject_train <- read.table("train/subject_train.txt", col.names = "subject")
x_test <- read.table("test/X_test.txt", col.names = features$functions)
y_test <- read.table("test/y_test.txt", col.names = "code")
x_train <- read.table("train/X_train.txt", col.names = features$functions)
y_train <- read.table("train/y_train.txt", col.names = "code")

#merge the test and train data
x_data<-rbind(x_test,x_train)
y_data<-rbind(y_test,y_train)
subject_data<-rbind(subject_test,subject_train)
after_merge<-cbind(x_data,y_data,subject_data)

#Extracts only the measurements on the mean and standard deviation for each measurement
after_merge1<-after_merge%>%select(subject,code,contains("mean"),contains("std"))

#Uses descriptive activity names to name the activities in the data set
after_merge1$code<-activities_labels[after_merge1$code,2]

#Appropriately labels the data set with descriptive variable names
names(after_merge1)[2]="activity"
names(after_merge1)<-gsub("Acc","Accelerometer",names(after_merge1))
names(after_merge1)<-gsub("Gyro","Gyroscope",names(after_merge1))
names(after_merge1)<-gsub("BodyBody","Body",names(after_merge1))
names(after_merge1)<-gsub("Mag","Magnitude",names(after_merge1))
names(after_merge1)<-gsub("^t","Time",names(after_merge1))
names(after_merge1)<-gsub("^f","Frequency",names(after_merge1))
names(after_merge1)<-gsub("tBody","TimeBody",names(after_merge1))
names(after_merge1)<-gsub("-mean()","Mean",names(after_merge1),ignore.case = TRUE)
names(after_merge1)<-gsub("-std()","STD",names(after_merge1),ignore.case = TRUE)
names(after_merge1)<-gsub("-freq()","Frequency",names(after_merge1),ignore.case = TRUE)
names(after_merge1)<-gsub("angle","Angle",names(after_merge1))
names(after_merge1)<-gsub("gravity","Gravity",names(after_merge1))

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
average_data<-after_merge1 %>% group_by(subject,activity) %>% summarise_all(funs(mean))




