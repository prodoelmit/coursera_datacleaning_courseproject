source("download.R")
trainset_data <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header=F  )
testset_data <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header=F  )

head(trainset_data)
dim(trainset_data)

head(testset_data)
dim(testset_data)

fulldata <- rbind(trainset_data, testset_data)

namesFile <- read.csv("./data/UCI HAR Dataset/features.txt", sep=" ", header=F)
names(namesFile) <- c("id", "name")
mean.or.std.cols <- grep("(mean|std)\\(\\)", namesFile$name)
fulldata.filtered <- fulldata[,mean.or.std.cols]

head(fulldata.filtered)
names(fulldata.filtered) <- namesFile$name[mean.or.std.cols]
head(fulldata.filtered)



