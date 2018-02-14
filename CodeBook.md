## Getting data

All the code for getting data is in `download.R`. It creates data directory if needed, downloads zip file with data supplied by course and unzips it. 

## Merging data

In `run_analysis.R` we start from sourcing `download.R` to prepare data files. Further both test and train data are being read from fixed width files using `read.table` function. Based on description that comes with data, both of them have the same column structure, so we can just `rbind` them together. 

## Naming data

`features_info.txt` described the features covered in train and test data. As pointed there, for each signal we have different characteristics, including `mean()` and `std()` ones. Those are what we need based on project description. 

Names of features are all listed in `features.txt` as space-delimited table, we can read it with `read.csv` with `sep=" "`. Then we need to filter out only columns with `mean` or `std` in its name - I use `grep` to find column indices which I then use to filter out data and to get names from `features.txt` table. 

## Cleaning names

Here comes the interesting part. Some of characteristics are prefixed by 't' denoting 'time domain', some by 'f' denoting 'frequency domain'. I filter out those `t`'s as time domains are what's meant by default for such data. For `f` I replace it with `Freqdomain` to be more descriptive. 

All filtered names are similar to `tBodyAccJerk-mean()-X`, but we would like it to look more like `body.acceleration.jerk.x.mean`, which tells that it's body acceleration's jerk signal, for which x component's mean is taken. Most of the work is done by `gsub` with pattern `"^([a-zA-Z]+)-(mean|std)\\(\\)(-([XYZ]))?" and then clearing dots in beginning of line, lowercasing everything and changing 'gyro' to 'angularvelocity' and 'acc' to 'acceleration'. The only thing left is the strange `fBodyBody...` group of signals. I suppose that's a typo, so in the end I replace `body.body` with single `body`. 

And the final thing to do is setting those names as names of our filtered data.

## Providing average of each variable

To get each variable we can use `sapply(fulldata.filtered, mean)`. This will get us to a vector with names. It would be better to present this data as `data.table` with columns `feature` and `mean.value`. For this I use `data.table(feature=names(m), mean.value = m)`, where `m` is previously mentioned vector. This gives us pretty two-column table. 
