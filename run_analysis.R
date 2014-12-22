run_analysis <- function(){
  inputPath = getwd()
  
  #################################################
  ###### Part 1. - merge test and train data ######
  #################################################
  
  # Load train and test data. 
  # Source data is X_train.txt and X_test.txt
  inputPathTrain <- paste(inputPath, "/train/X_train.txt", sep="")
  if(!exists("trainData")){
    trainData <<- read.table(inputPathTrain)
  }
  inputPathTest <- paste(inputPath, "/test/X_test.txt", sep="")
  if(!exists("testData")){
    testData <- read.table(inputPathTest)
  }
  #Merge train and test data.
  if(!exists("mergedData")){
    mergedData <- rbind(trainData, testData)
  }
  
  #################################################
  ######### Part 2. - Fetch  mean and std #########
  #################################################
   
  # Info about necessary columns is found in features.txt
  inputPathFeatures <- paste(inputPath, "/features.txt", sep="")
  featuresData <- read.table(inputPathFeatures)
  colnames(featuresData) <- c("cIndex", "fName")
  #Filter only mean and std column indices and column names
  filteredFeaturesData <- featuresData[grep("std|mean", featuresData$fName),]
  #Get indices in vector and fetch all merged data rows with specific columns 
  filteredData <- mergedData[,c(t(filteredFeaturesData[1]))]
  
  #################################################
  ######### Part 3. - name the activities #########
  #################################################

  #Load named activities from activity_labels.txt 
  inputPathActivityLabels <- paste(inputPath, "/activity_labels.txt", sep="")
  activityLabelsData <- read.table(inputPathActivityLabels)
  colnames(activityLabelsData) <- c("aIndex", "label")
  #Load activities row by row from y_train.txt and y_test.txt.
  inputPathActivityTrain <- paste(inputPath, "/train/y_train.txt", sep="")
  inputPathActivityTest <-  paste(inputPath, "/test/y_test.txt", sep="") 
  activityTrainData <- read.table(inputPathActivityTrain)
  activityTestData <- read.table(inputPathActivityTest)
  #Merge activities data into single table
  activityData <- rbind(activityTrainData, activityTestData)
  colnames(activityData) <- c("aIndex")
  #Add column with label to each activity row 
  activityData$label <- activityLabelsData[match(activityData$aIndex, activityLabelsData$aIndex), "label"]
   
  #################################################
  ### Part 4. - set descriptive variable names  ###
  #################################################
  
  #We can do like this because we didn't add activity column yet.
  colnames(filteredData) <- filteredFeaturesData$fName
  
  #################################################
  #########  Part 5. - create tidy data  ##########
  #################################################
  
  #Add subject columns to the data set.
  #Source files are subject_train.txt and subject_test.txt 
  inputPathSubjectTrain <- paste(inputPath, "/train/subject_train.txt", sep="")
  inputPathSubjectTest <- paste(inputPath, "/test/subject_test.txt", sep="")
  subjectTrainData <- read.table(inputPathSubjectTrain)
  subjectTestData <- read.table(inputPathSubjectTest)
  subjectData <- rbind(subjectTrainData, subjectTestData)
  colnames(subjectData) <- c("subject")
  filteredData$subject <- subjectData$subject
  #Add activity column to the data set from the values we calculated in step 3
  filteredData$activity <- activityData$label
  #Load dplyr and reshape packages to melt, make group and summarize (create mean)
  library(dplyr)
  library(reshape2)
  #Transform from wide to long format, group by and calculate mean
  meltedData <- melt(filteredData, id.vars = c("subject", "activity"))
  groupedData <- group_by(meltedData, activity, subject, variable)
  summarizedData <- summarise(groupedData, mean=mean(value))
  #Change column names with "Mean of ... "
  columnNames <- paste("Mean of", summarizedData$variable)
  summarizedData$variable <- columnNames 
  #Transform from long to wide data format
  tidyData <- dcast(summarizedData, subject + activity ~ variable)
  #Output data to file
  outputPathFile = paste(inputPath, "/tidy_data.txt", sep="")
  write.table(tidyData, outputPathFile, row.names = FALSE)
}