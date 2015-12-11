# Description of the script run_analysis.R

This script is used to clean and subset the data from the Human Activity 
Recognition Using Smartphones Datasets. The original data is available at this
address : [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip )

## Files used

First, the script will read the files we are interested in.

- **UCI HAR Dataset/test/X_test.txt** and **UCI HAR Dataset/train/X_train.txt** : test and training sets containing the data for 561 features.
- **UCI HAR Dataset/test/y_test.txt** and **UCI HAR Dataset/train/y_train.txt** : identifiers for the type of activity, for the test and training sets.
- **UCI HAR Dataset/test/subject_test.txt** and **UCI HAR Dataset/train/subject_train.txt** : identifiers of the subject, for the test and training sets.
- **UCI HAR Dataset/features.txt** : names of the 561 features used in the test and training sets.
- **UCI HAR Dataset/activity_labels.txt** : name of the activity corresponding to each activity identifier.

## Labeling the variables

The features in the test and training sets are not named, and the datasets used identifiers instead of names for the type of activity.

The script will assign meaningfull names to the variables.

- **Subject identifier** : *subject_id*
- **Activity identifier** : *activity_id*
- **Activity name** : *activity_name*
- **Features** : names of the features described in features.txt

## Constructing the total dataset

Since the informations we want are scattered in different files, we are going to assemble them in one unique dataset called *data*.

First we are going to assign the activity names in activity_labels.txt to the activity identifiers in y_test.txt and y_train.txt. Then we will construct 2 datasets (one for the test set (*test_data*) and one for the training set (*training_data*)) by binding together the subject identifiers, the activity identifiers, the activity names, and finally the 561 features contained in X_test.txt and X_train.txt.

The last step is to bind together the test and training datasets we obtained to create the new dataset *data*. 

## Extracting the mean and standard deviation measurements

We are only interested in the features describing the mean and standard deviation of the measurements. We are going to extract these features frome the data frame *data* by using regular expressions. We search for the features with names containing **-mean()** or **-std()**. We create a new dataset *data_sub* containing the subject identifier, the activity identifier, the activity name, and then the features we extracted. 

## Creating a dataset with the averages of each variable for each activity and each subject

The last step is to create a new dataset which will contain the averages of these features for each subject and each activity.

I used the **ddply** function from the **plyr** package. It is similar to the base funtion **by**, but instead of returning a list, it returns a data frame, which is much more convenient. This function will split the data frame frame from the last step *data_sub* by two factors : *subject_id* and *activity_name*. The **numcolwise** function is used to compute the mean for each remaining column. The resulting data frame is called *data_average*.



























