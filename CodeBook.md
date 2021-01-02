# Welcome to my project!

Hi! This is my project on the Coursera peer review project of the course Getting and Cleanning Data. My name is Alan and I'm still learning all this data and programming thing, so I welcome any constructive criticism. Thank you!


# The Dataset

The dataset offered with wearable data was in .txt format and in different files. After downloading and unziping the files, the script will create several data tables for train or test (X, Y and Subjects). The activitylabel contains the index of activities, divided in walking, walking upstairs, walking downstairs, sitting, standing or laying, numbered from 1 to 6.

## Sanity Check

Since the sets have no header names, the first thing done after loading the data sets was a sanity check. The table "feats", for instance, contained all the names for "xtrain" and "xtest", and they were dutifuly mixed using colnames. 

    colnames(xtrain) <- feats[,2]
"ytrain" and "sub_train" also passed a colnames, using 'activityId' and 'subjectId' respectively.

## Merging the sets

At first I merged all created train 
sets using cbind:

    alltrain <- cbind(ytrain, sub_train, xtrain)
Test data also passed by the same process:

    alltest <- cbind(ytest, sub_test, xtest)

After creating two tables that merged all train and test datas, they should be merged as well. However, instead of using cbind, now I used rbind, since both sets had the same heads:

    mergedDF <- rbind(alltrain, alltest)

## Extracting the measurments on the mean and SD for each activity

Using the merged data set, I created a variable named columnsname. The idea was then to use grepl() to search for all column names that had the words 'mean' or 'std' in it and store the value in 'meanSD'. After that, using 'meanSD' as a logical check = True, I stored the result in a new DF called "DFmeanSD".

    columnsname <- colnames(mergedDF)
    meanSD <- (grepl("activityId", columnsname) | grepl("subjectId", columnsname) | grepl("mean..", columnsname)| grepl("std..", columnsname))
    DFmeanSD<- mergedDF[,meanSD == T]

## Using descriptive names for the data set

As requested, I also changed the names of several variables, making them more descriptive. For instance, variables that started with "t" would be renamed "time", and those that started with "f" would be renamed "frequency. That required 6 lines of codes, each one changing a name.

    names(DFmeanSD) <- gsub("^t", "time", names(DFmeanSD))
    names(DFmeanSD) <- gsub("^f","frequency",names(DFmeanSD))
    names(DFmeanSD) <- gsub("BodyBody","Body",names(DFmeanSD))
    names(DFmeanSD) <- gsub("Acc","Accelerometer", names(DFmeanSD))
    names(DFmeanSD) <- gsub("Mag","Magnitude",names(DFmeanSD))
    names(DFmeanSD) <- gsub("Gyro","Gyroscope",names(DFmeanSD))

## Creating a tidy data

After all that renaming, I used aggregate() with the objects 'subjectId' and 'activityId', using the DFmeanSD data set and the mean function.
With the newly created tidyDF, I ordered firstly by subjectId and then by activityId, overwriting tidyDF

    tidyDF <- aggregate(. ~subjectId + activityId, DFmeanSD, mean)
    tidyDF <- tidyDF[order(tidyDF$subjectId, tidyDF$activityId),]

After that, I created a txt file called 'tidy_data.txt' with the write.table function.

    write.table(tidyDF, file = 'tidy_data.txt', row.name=F)
That's it!
Have a great year!
Alan R.
01-01-2021
