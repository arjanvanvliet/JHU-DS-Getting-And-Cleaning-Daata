# JHU - Data Science
# Module 3. Getting and Cleaning Data
# Final Assignment

# Assignment objectives:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the
#    average of each variable for each activity and each subject.

library(plyr)

# Load the features
features <- read.table("./data/UCI HAR Dataset/features.txt")

# Load the dataset and set the correct labels
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt", col.names = "Activity")
subjects_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt", col.names = "Activity")
subjects_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
names(x_test) <- features$V2
names(x_train) <- features$V2

# Merge the test and training datasets
x_combined <- rbind(x_test, x_train)
y_combined <- rbind(y_test, y_train)
subjects_combined <- rbind(subjects_test, subjects_train)

# Select the relevant columns
columns <- grep("-(mean|std)\\(", features$V2)
x_new <- x_combined[,columns]

# Set descriptive activity names
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
names(activities) <- c("Activity", "V2")
y_combined_descriptive <- join(y_combined, activities)

# Combine and set descriptive variable names
combined <- cbind(subjects_combined, y_combined_descriptive$V2, x_new)
data.table::setnames(combined, "y_combined_descriptive$V2", "Activity")

# Create a new tidy dataset with averages of each variable for each activity and each subject
nw_tidy_data <- ddply(combined, c("Subject", "Activity"), function(x) colMeans(x[,3:68]))
write.table(nw_tidy_data, "./data/tidy_data.txt", row.name=FALSE)
