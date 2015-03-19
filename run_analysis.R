# run_analysis.R script performs the following steps

library(plyr)

# 1. Merges the training and the test sets to create one data set.

# create 'x_Data' data set
xtrain <- read.table("./train/X_train.txt")
xtest <- read.table("./test/X_test.txt")
x_Data <- rbind(xtrain, xtest)

# create 'y_Data' data set
ytrain <- read.table("./train/y_train.txt")
ytest <- read.table("./test/y_test.txt")
y_Data <- rbind(ytrain, ytest)
# create 's_Data' data set
strain <- read.table("./train/subject_train.txt")
stest <- read.table("./test/subject_test.txt")
s_Data <- rbind(ytrain, ytest)
# 2.Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("./features.txt")
# get only columns with mean() or std() in their names
mean_and_std  <- grep("-(mean|std)\\(\\)", features[, 2])
#subset columns
x_Data <- x_Data[, mean_and_std]
#name columns
names(x_Data) <-  features[mean_and_std, 2]

# 3.Use descriptive activity names to name the activities in the data set
activities <- read.table("./activity_labels.txt")
activities[, 2] = gsub("_", "", tolower(as.character(activities[, 2])))
y_Data[,1] <- activities[y_Data[,1], 2]
names(y_Data) <- "activity"

# 4.Appropriately label the data set with descriptive variable names
# correct column name
names(s_Data) <- "subject"
labled_data <- cbind(x_Data, y_Data, s_Data)
#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for
#each activity and each subject.
averages_data <- ddply(labled_data, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(averages_data, "averages_data.txt", row.name=FALSE)
