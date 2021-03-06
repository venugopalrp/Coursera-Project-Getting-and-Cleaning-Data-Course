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
s_Data <- rbind(strain, stest)
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
labled_data <- cbind(  s_Data, y_Data, x_Data)
#5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for
#each activity and each subject.
averages_data <- ddply(labled_data, .(subject, activity), function(x) colMeans(x[, 3:68]))
write.table(averages_data, "averages_data.txt", row.name=FALSE)

# 5. Creates a 2nd, independent tidy data set with the average of each variable for each activity and each subject.

#uniqueSubjects = unique(s_Data)[,1]
#numSubjects = length(unique(s_Data)[,1])
#numActivities = length(activities[,1])
#numCols = dim(labled_data)[2]
#result = labled_data[1:(numSubjects*numActivities), ]

#row = 1
#for (s in 1:numSubjects) {
#        for (a in 1:numActivities) {
#                result[row, 1] = uniqueSubjects[s]
#                result[row, 2] = activities[a, 2]
#                tmp <- labled_data[labled_data$subject==s & labled_data$activity==activities[a, 2], ]
#                result[row, 3:numCols] <- colMeans(tmp[, 3:numCols])
#                row = row+1
#        }
#}
#write.table(result, "dataset_with_avgs.txt")
