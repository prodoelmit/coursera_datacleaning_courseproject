library(data.table)
library(tidyr)
library(dplyr)

# Getting data
source("download.R")

# Merging data
trainset_data <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header=F  )
trainset_labels <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header=F )
testset_data <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header=F  )
testset_labels <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header=F )
fulldata <- rbind(trainset_data, testset_data)
fulllabels <- as_tibble(rbind(trainset_labels, testset_labels))
names(fulllabels) <- c("activity.label.id")

# head(trainset_data)
# dim(trainset_data)

# head(testset_data)
# dim(testset_data)

# Naming data
namesFile <- read.csv("./data/UCI HAR Dataset/features.txt", sep=" ", header=F)
names(namesFile) <- c("id", "name")
mean.or.std.cols <- grep("(mean|std)\\(\\)", namesFile$name)
fulldata.filtered <- fulldata[,mean.or.std.cols]

# Cleaning names
ns <- namesFile$name[mean.or.std.cols]
ns <- gsub("^t","", ns)
ns <- gsub("^f","Freqdomain", ns)
ns <- gsub("^([a-zA-Z]+)-(mean|std)\\(\\)(-([XYZ]))?", "\\1\\4.\\2", ns)
ns <- gsub("([A-Z])", ".\\1", ns)
ns <- gsub("^\\.", "", ns)
ns <- tolower(ns)
ns <- gsub("body\\.body", "body", ns)
ns <- gsub("mag", "magnitude", ns)
ns <- gsub("acc", "acceleration", ns)
ns <- gsub("gyro", "angularvelocity", ns)

names(fulldata.filtered) <- ns

# Joining with persons and labels
persons <- as_tibble(rbind(
				 read.table("./data/UCI HAR Dataset/train/subject_train.txt"),
				 read.table("./data/UCI HAR Dataset/test/subject_test.txt")
				 ))
activity.labels <- fulllabels %>% 
	inner_join( as_tibble(read.table("./data/UCI HAR Dataset/activity_labels.txt", col.names=c("activity.label.id", "activity.label"))))


# Aggregating mean for each activity.label&person.id 
data <- as_tibble(fulldata.filtered) %>% 
	aggregate(by=list(activity.labels$activity.label, persons$V1), mean)
names(data)[1] <- "activity.label"
names(data)[2] <- "person.id"

write.table(data, "meandata.txt")
