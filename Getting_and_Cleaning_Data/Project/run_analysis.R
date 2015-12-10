

########################################################################
#  This script perform the cleaning and tidying of the Human Activity  #
#  Recognition Using Smartphones Dataset                               #
########################################################################

# Reading test set
test <- read.table("UCI HAR Dataset/test/X_test.txt")
test_activity_id <- read.table("UCI HAR Dataset/test/y_test.txt")
test_subject_id <- read.table("UCI HAR Dataset/test/subject_test.txt")

# Reading train set
train <- read.table("UCI HAR Dataset/train/X_train.txt")
train_activity_id <- read.table("UCI HAR Dataset/train/y_train.txt")
train_subject_id <- read.table("UCI HAR Dataset/train/subject_train.txt")

# Reading labels files
features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")


############################
#  Labeling the variables  #
############################

# Labeling the variables according to features.txt
features$V2 <- as.character(features$V2)
colnames(test) <- features$V2
colnames(train) <- features$V2

# Labeling the activity id variables
colnames(test_activity_id) <- "activity_id"
colnames(train_activity_id) <- "activity_id"

# Labeling the subject id variable
colnames(test_subject_id) <- "subject_id"
colnames(train_subject_id) <- "subject_id"

# Labeling the activity name variable
colnames(activity_labels) <- c("activity_id", "activity_name")


####################################
#  Constructing the total dataset  #
####################################

# Merging the activity id and the activity label
test_activity_name <- merge(test_activity_id, activity_labels, sort = FALSE)
train_activity_name <- merge(train_activity_id, activity_labels, sort = FALSE)
# Constructing the test and train datasets
test_data <- cbind(test_subject_id, test_activity_name, test)
train_data <- cbind(train_subject_id, train_activity_name, train)
# Combining the test and train datasets
data <- rbind(test_data, train_data)


##########################################################
#  Extract the mean and standard deviation measurements  #
##########################################################

# Getting the names of the variables measuring mean and standard deviation
names_mean <- grep(pattern = ".*-mean[()].*", x = colnames(data), value = TRUE)
names_std <- grep(pattern = ".*-std[()].*", x = colnames(data), value = TRUE)

# Subsetting the wanted columns
data_sub <- data[,c("subject_id",
                    "activity_id",
                    "activity_name",
                    names_mean,
                    names_std)]


#############################################################################
#  Creating a dataset with the averages of each variable for each activity  #
#  and each subject                                                         #
#############################################################################

library(plyr)
data_average <- ddply(data_sub, .(subject_id, activity_name), numcolwise(mean))

# Writing the final dataset in a file
write.table(data_average, file = "data_average.txt", row.names = FALSE)













































