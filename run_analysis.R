
#Merge the tarining and the test datasets and subset the data to have only the mean and std values
mergeData <- function() {
	#Read the y data.
   pathToFile <- "test/y_test.txt"
   yDat <- read.table(pathToFile, header=F, col.names=c("ActivityID"))
   pathToFile <- "train/y_train.txt"
   yDatTrain <- read.table(pathToFile, header=F, col.names=c("ActivityID"))
    
   pathToFile <- "test/subject_test.txt"
   
   #Get the subject data
   sDat <- read.table(pathToFile, header=F, col.names=c("SubjectID"))
	pathToFile <- "train/subject_train.txt"
   sDatTrain <- read.table(pathToFile, header=F, col.names=c("SubjectID"))
    
    #Get the names of columns
    colData <- read.table("features.txt", header=F, as.is=T, col.names=c("FeatureID", "FeatureName"))
    #Read the X data
    pathToFile <- "test/x_test.txt"
    d <- read.table(pathToFile, header=F, col.names= colData$FeatureName)
	pathToFile <- "train/x_train.txt"
    dTrain <- read.table(pathToFile, header=F, col.names= colData$FeatureName)
    reqD <- grep(".*mean\\(\\)|.*std\\(\\)", colData$FeatureName)
	reqDTrain <- grep(".*mean\\(\\)|.*std\\(\\)", colData$FeatureName)
    d <- d[,reqD]
    dTrain <- dTrain[,reqDTrain]

    # append the activity and subject id columns
    d$ActivityID <- yDat$ActivityID
    d$SubjectID <- sDat$SubjectID
    
    dTrain$ActivityID <- yDatTrain$ActivityID
    dTrain$SubjectID <- sDatTrain$SubjectID
        
    mDat <- rbind(d, dTrain)
    mDat
}

# Add the activity names as another column
addLabel <- function(data) {
    labels <- read.table("activity_labels.txt", header=F, as.is=T, col.names=c("ActivityID", "ActivityName"))
    labels $ActivityName <- as.factor(labels $ActivityName)
    labeledData <- merge(data, labels)
    labeledData
}

# Combine the two data sets and add the activity label as a column
MergeAndLabelData <- function() {
    addLabel(mergeData())
}

#Here we receive the data frame that is already merged and labelled and create a dataset containing the average of each variable for each activity and each subject.
processData <- function(processedData) {
    library(reshape2)
    
    # melt
    id_vars = c("ActivityID", "ActivityName", "SubjectID")
    feature_vars = setdiff(colnames(processedData), id_vars)
    melted_data <- melt(processedData, id=id_vars, measure.vars= feature_vars)
    
    # recast 
    dcast(melted_data, ActivityName + SubjectID ~ variable, mean)    
}

# Process the data as required, create the tidy data set and write it into a file
startProcessing <- function(file_name) {
    final_data <- processData(MergeAndLabelData())
    write.table(final_data, file_name)
}

print("Processing data and creating a tidy data set.")
startProcessing("tidyData.txt")
print("Please check your root folder for tidyData.txt")
