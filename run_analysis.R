###Downloading and unzipping the data ====
if(!file.exists("./data")){dir.create("./data")} #creates a dir on wd
fileUrl<- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/Dataset.zip") #download the file
unzip("./data/Dataset.zip", exdir="./data") #unzips the file to the created dir
list.files("./data") 
datapath<-file.path("./data","UCI HAR Dataset")
files<- list.files(datapath, recursive = T) #lists all files in dir and subdir
files

###Creating data sets ====
xtrain <- read.table(file.path(datapath, "train","X_train.txt"),header =F)
ytrain <- read.table(file.path(datapath, "train","Y_train.txt"),header=F)
sub_train <- read.table(file.path(datapath,"train","subject_train.txt"),header=F)
xtest <- read.table(file.path(datapath,"test","X_test.txt"),header=F)
ytest <- read.table(file.path(datapath,"test","y_test.txt"),header=F)
sub_test <- read.table(file.path(datapath,"test","subject_test.txt"),header=F)
feats <- read.table(file.path(datapath, "features.txt"),header = F)
activityLabels <- read.table(file.path(datapath, "activity_labels.txt"),header = F)


#creating sanity check for the datas
colnames(xtrain) <- feats[,2] #this will use the feats to name columns in xtrain
colnames(ytrain) = "activityId"
colnames(sub_train) = "subjectId"
colnames(xtest) <-  feats[,2] #same as above
colnames(ytest) = "activityId"
colnames(sub_test) = "subjectId"
colnames(activityLabels) <- c('activityId','activityType')

##1. Merges the training and the test sets to create one data set.
alltrain <- cbind(ytrain, sub_train, xtrain)
alltest <- cbind(ytest, sub_test, xtest)

mergedDF <- rbind(alltrain, alltest)


##2. Extracts only the measurements on the mean and standard deviation for each measurement. 
columnsname <- colnames(mergedDF)
meanSD <- (grepl("activityId", columnsname) | grepl("subjectId", columnsname) | grepl("mean..", columnsname)| grepl("std..", columnsname))
mergedDF[,meanSD == T]
DFmeanSD<- mergedDF[,meanSD == T]


##3. Use descriptive activity names to name the activities in the data set
##4. Appropriately labels the data set with descriptive variable names. 
#some of that was done above when creating a sanity check
names(DFmeanSD) <- gsub("^t", "time", names(DFmeanSD))
names(DFmeanSD) <- gsub("^f","frequency",names(DFmeanSD))
names(DFmeanSD) <- gsub("BodyBody","Body",names(DFmeanSD))
names(DFmeanSD) <- gsub("Acc","Accelerometer", names(DFmeanSD))
names(DFmeanSD) <- gsub("Mag","Magnitude",names(DFmeanSD))
names(DFmeanSD) <- gsub("Gyro","Gyroscope",names(DFmeanSD))


##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyDF <- aggregate(. ~subjectId + activityId, DFmeanSD, mean)
tidyDF <- tidyDF[order(tidyDF$subjectId, tidyDF$activityId),]


##Saving the tidy dataset in a local file
write.table(tidyDF, file = 'tidy_data.txt', row.name=F)