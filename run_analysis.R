library(data.table)

# Getting data
source("download.R")

# Merging data
trainset_data <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header=F  )
testset_data <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header=F  )
fulldata <- rbind(trainset_data, testset_data)

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
#head(fulldata.filtered)

# Providing average of each variable
m <- sapply(fulldata.filtered, mean)
meandata <- data.table(feature = names(m), mean.value = m)

write.table(meandata, file="meandata.txt", row.names=F)
meandata

