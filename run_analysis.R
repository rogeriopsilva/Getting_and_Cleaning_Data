##run_analysis.R
##
##
library(data.table)
furl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "

##Download the fie and unzip it just once to improve the performance 
if(!file.exists("getdata_projectfiles_UCI_HAR_Dataset.zip")){
	download.file(furl1, destfile = "getdata_projectfiles_UCI_HAR_Dataset.zip", method = "curl")
	unzip("getdata_projectfiles_UCI_HAR_Dataset.zip")
}

##creates the test and training datasets 
testData <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
testData_act <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
testData_sub <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
trainData_act <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
trainData_sub <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
##
##Sets descriptive activity names to name the activities in the data set
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
testData_act$V1 <- factor(testData_act$V1,levels=activities$V1,labels=activities$V2)
trainData_act$V1 <- factor(trainData_act$V1,levels=activities$V1,labels=activities$V2)
##
##Sets the column names on test and training datasets
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
colnames(testData)<-features$V2
colnames(trainData)<-features$V2
colnames(testData_act)<-c("Activity")
colnames(trainData_act)<-c("Activity")
colnames(testData_sub)<-c("Subject")
colnames(trainData_sub)<-c("Subject")
##
##Creates a new dataset based on test and training datasets by merging them
testData<-cbind(testData,testData_act)
testData<-cbind(testData,testData_sub)
trainData<-cbind(trainData,trainData_act)
trainData<-cbind(trainData,trainData_sub)
allData<-rbind(testData,trainData)
##
##Identifies the measurements on the mean and standard deviation for each measurement 

colsMeanStd<-features$V2[grep(".*[Mm]ean|[Ss]td.*",features$V2)]
AllDataMS<-allData[,c(colsMeanStd,"Activity","Subject")]

##Extracts only the measurements on the mean and standard deviation for each measurement
DT <- data.table(AllDataMS)
write.table(DT,file="tidy0.txt",sep=",",row.names = FALSE)
##
##
####ALTERAR sep=";" para sep=","
##Creates the second, independent tidy data set with the average of each variable for each activity and each subject
tidy1<-aggregate(DT, by=list(Activity = DT$Activity, Subject=DT$Subject), mean)
col2xport<-1:(ncol(tidy1)-2)
write.table(tidy1[,col2xport],file="tidy1.txt",sep=",",row.names = FALSE)

