setwd("C:/bd/coursera/wd")

## STEP 1: Merges the training and the test sets to create one data set
sub.te <- read.table("data/UCI_HAR_Dataset/test/subject_test.txt")
sub.tr <- read.table("data/UCI_HAR_Dataset/train/subject_train.txt")

X.te <- read.table("data/UCI_HAR_Dataset/test/X_test.txt")
X.tr <- read.table("data/UCI_HAR_Dataset/train/X_train.txt")

y.te <- read.table("data/UCI_HAR_Dataset/test/y_test.txt")
y.tr <- read.table("data/UCI_HAR_Dataset/train/y_train.txt")

# add column name for subject files
names(sub.te) <- "subjectID"
names(sub.tr) <- "subjectID"

# add column names for measurement files
f <- read.table("data/UCI_HAR_Dataset/features.txt")
names(X.te) <- f$V2
names(X.tr) <- f$V2

# add column name for label files
names(y.te) <- "activity"
names(y.tr) <- "activity"

# combine files into one dataset
tr <- cbind(sub.tr, y.tr, X.tr)
te <- cbind(sub.te, y.te, X.te)
trte <- rbind(tr, te)

## STEP 2: Extracts only the measurements on the mean and standard
## deviation for each measurement.

# Get "mean()" or "std()" columns
trte.m.std <- grepl("mean\\(\\)", names(trte)) | grepl("std\\(\\)", names(trte))

# Retain subjectID and activity columns
trte.m.std[1:2] <- TRUE

# remove other columns
trte <- trte[, trte.m.std]

## STEP 3: Uses descriptive activity names to name the activities
## in the data set.
## STEP 4: Appropriately labels the data set with descriptive
## activity names. 

# convert the activity column from integer to factor
trte$activity <- factor(trte$activity, labels=c("Walking",
                                                "Walking Upstairs", 
                                                "Walking Downstairs", 
                                                "Sitting", 
                                                "Standing", 
                                                "Laying"))


## STEP 5: Creates a second, independent tidy data set with the
## average of each variable for each activity and each subject.

# create the tidy data set
library(reshape2)
meltedds <- melt(trte, id=c("subjectID","activity"))
tidyds <- dcast(meltedds, subjectID+activity ~ variable, mean)

# write the tidy data set to a file
write.table(tidyds, "data/UCI_HAR_Dataset/tidyds.txt", row.names=FALSE)




