
# Loads the library
library ("data.table")


# Sets the working directory.
# Changes this to your current working directory.
setwd("C:\\Users\\gomezaa\\Documents\\GitHub\\DataScienceWithR\\3GettingandCleaningData\\Project")

# Creates the general paths

# Sets the general path
generalPath <- getwd()
generalPath

# The path to the data set 
datasetPath <- file.path(generalPath, "UCI HAR Dataset")
list.files(datasetPath)

# # # # # # #
# Read the test and train files

# Reads the subject files for train and test.
dtSubjectTrain <- fread(file.path(datasetPath, "train", "subject_train.txt"))
dtSubjectTest  <- fread(file.path(datasetPath, "test" , "subject_test.txt" ))


# Reads the labels files for train and test.
dtLabelsTrain <- fread(file.path(datasetPath, "train", "Y_train.txt"))
dtLabelsTest  <- fread(file.path(datasetPath, "test" , "Y_test.txt" ))

# Reads the sets for train and test.
dataFrameToDataTable <- function(path){
    dataFrame <- read.table(path)
    dataTable <- data.table(dataFrame)
};

dtTrainSet <- dataFrameToDataTable(file.path(datasetPath, "train", "X_train.txt"))
dtTestSet  <- dataFrameToDataTable(file.path(datasetPath, "test" , "X_test.txt" ))

# # # # # # # # # # # # # #
# 1. Merges the training and the test sets to create one data set.

# Merge by rows.

# Merge the subjects by row 
dtSubject <- rbind(dtSubjectTrain, dtSubjectTest)
# Rename the col name.
setnames(dtSubject, "V1", "subject")

# Merges the labels by row
dtLabels <- rbind(dtLabelsTrain, dtLabelsTest)
setnames(dtLabels, "V1", "activityId")

# Merges the sets by row, no need set a name.
dtSet <- rbind(dtTrainSet, dtTestSet)

# Merge by colums to obtain one big data table.

# Merges the subject with the avtivity labels (numbers).
dtGeneral <- cbind(dtSubject,dtLabels)

# Merges the sets.
dtGeneral <- cbind(dtGeneral, dtSet)

# Sets a key for the dt
setkey(dtGeneral, subject, activityId)

# # # # # # # # # # # # # #
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# Baed on "features_info.txt" the "features.txt" contains the features.
# Reads the file.
dtFeatures <- fread(file.path(datasetPath, "features.txt"))
setnames(dtFeatures, c("V1","V2"), c("featureNum","featureName"))

# Gets only the mean "mean" and standard deviation "std" features.
# Searh for the patter to replace.
dtFeatures <- dtFeatures[grepl("mean\\(|std\\(",featureName)]

# Adds a new column wiht the feature id, based in the current variable name (v1,v2,etc)
dtFeatures$featureId <- dtFeatures[, paste0("V", featureNum)]

# Subsets only the "dtFeatures$featureId"  variables.
dtGeneral <- dtGeneral[, c(key(dtGeneral), dtFeatures$featureId), with=FALSE]


# # # # # # # # # # # # # #
# 3. Uses descriptive activity names to name the activities in the data set
# Based on the 'activity_labels.txt' file, sets the name to the activities.

# Reads the activity_labels.txt file
dtActivityLabels <- fread(file.path(datasetPath, "activity_labels.txt"))
setnames(dtActivityLabels, names(dtActivityLabels), c("activityId", "activityName"))

# Adds the activity names to the general data set.
dtGeneral <- merge(dtGeneral, dtActivityLabels, by="activityId", all.x=TRUE)
# Adds the activity name as a key.
setkey(dtGeneral, subject, activityId, activityName)

# # # # # # # # # # # # # #
# 4. Appropriately labels the data set with descriptive variable names. 

# Sets the "v" variables as rows by melt it by the fearure Id.
dtGeneral <- data.table( melt(dtGeneral, key(dtGeneral), variable.name="featureId"))

# Merges the features (activity) name.
featureOrder <- dtFeatures[, list(featureNum, featureId, featureName)]
dtGeneral <- merge(dt,featureOrder , by="featureId", all.x=TRUE)

dtGeneral2 <- dtGeneral

# Adds an activity and feature factor in order to use the grepl command
dtGeneral$activity <- factor(dtGeneral$activityName)
dtGeneral$feature <- factor(dtGeneral$featureName)

# Finds a pattern in the general DT by using the grepl command.
findPattern <- function (regex) {
    grepl(regex, dtGeneral$feature)
}

# # Features with 1 category.

# Gets the "Magnitude"
dtGeneral$featureJerk <- factor(findPattern("Jerk"), labels=c(NA, "Jerk"))
dtGeneral$featureMagnitude <- factor(findPattern("Mag"), labels=c(NA, "Magnitude"))

# # Features with 2 categories
n <- 2

# Gets the "Time" and  "Freq".
y <- matrix( seq(1, n), nrow = n)
x <- matrix(c(findPattern("^t"), findPattern("^f")), ncol=nrow(y))
dtGeneral$featureDomain <- factor(x %*% y, labels=c("Time", "Freq"))

# Gets the "Accelerometer" and "Gyroscope".
x <- matrix(c(findPattern("Acc"), findPattern("Gyro")), ncol=nrow(y))
dtGeneral$featureInstrument <- factor(x %*% y, labels=c("Accelerometer", "Gyroscope"))

# Gets the "Body" and "Gravity".
x <- matrix(c(findPattern("BodyAcc"), findPattern("GravityAcc")), ncol=nrow(y))
dtGeneral$featureAcceleration <- factor(x %*% y, labels=c(NA, "Body", "Gravity"))

# Gets the "Mean" and "SD"
x <- matrix(c(findPattern("mean()"), findPattern("std()")), ncol=nrow(y))
dtGeneral$featureVariable <- factor(x %*% y, labels=c("Mean", "SD"))

# # Features with 3 categories
n <- 3

# Gets the 3-axial signals "X" "Y" and "Z".
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c( findPattern("-X"), findPattern("-Y"), findPattern("-Z")), ncol=nrow(y))
dtGeneral$featureAxis <- factor(x %*% y, labels = c(NA, "X", "Y", "Z"))


# # # # # # # # # # # # # #
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Sets a key to do the mean.
setkey(dtGeneral, subject, activity, featureDomain, featureAcceleration, featureInstrument, featureJerk, featureMagnitude, featureVariable, featureAxis)
# Creates the tidy data set.
TidyDataSet <- dtGeneral[, list(count = .N, average = mean(value)), by = key(dtGeneral)]

# Write the final result to a txt file.
fileConn <- file("TidyDataSet.txt")
write.table(TidyDataSet, row.name = FALSE, fileConn)
close(fileConn)


# References
# https://class.coursera.org/getdata-007/forum/thread?thread_id=49
# https://github.com/benjamin-chan