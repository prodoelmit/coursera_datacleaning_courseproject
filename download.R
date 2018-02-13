dataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

dataDir <- "./data"
if (!file.exists(dataDir)) {
	dir.create(dataDir)
}

zipPath <- "./data/dataset.zip"
datasetDir <- "./data/UCI HAR Dataset"

if (!file.exists(datasetDir)) {
	download.file(dataUrl, dest=zipPath)
	unzip(zipPath, exdir=dataDir)
}

