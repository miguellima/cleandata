library(plyr)

# Read the training and test sets

x_train <- read.table("train/X_train.txt")
y_train <- read.table("train/y_train.txt")
subject_train <- read.table("train/subject_train.txt")

x_test <- read.table("test/X_test.txt")
y_test <- read.table("test/y_test.txt")
subject_test <- read.table("test/subject_test.txt")

# create values data set
data <- rbind(x_train, x_test)

# create labels data set
labels <- rbind(y_train, y_test)

# create subjects data set
subjects <- rbind(subject_train, subject_test)


# get only the mean and std dev for each measurement


features <- read.table("features.txt")

# get only columns with mean() or std() in their names
columns <- grep("-(mean|std)\\(\\)", features[, 2])

# subset means and std
data <- data[, columns]

# correct the column names
names(data) <- features[columns, 2]

# descriptive activity names to label the activities in the data

activities <- read.table("activity_labels.txt")
labels[, 1] <- activities[labels[, 1], 2]

# correct column name
names(labels) <- "activity"

# correct column name
names(subject_data) <- "subject"

# join in a single data set
full <- cbind(data, labels, subject_data)

headers <- names(full)
headers <- gsub('-mean', 'Mean', headers)
headers <- gsub('-std', 'Std', headers)
headers <- gsub('[()-]', '', headers)
headers <- gsub('BodyBody', 'Body', headers)
colnames(full)<- headers

# calculate avg
averages <- ddply(full, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(averages, "averages_data.txt", row.name=FALSE)