run_run_analysis <- function() {
  library(data.table)
  library(dplyr)
  library(reshape2)
  library(rapportools)
  
  localDebug <- FALSE
  
  if(localDebug){
    # set working directory
    setwd("C:/Users/Home/Documents/- Data Science/DataCleaning/dataCleaningPeerProject")
  }
  
  
  # Read in list of features. Note: this is a list of the labels for column labels
  features <-
    read.table(
      "./UCI HAR Dataset/features.txt",
      quote = "\"",
      stringsAsFactors = FALSE
    )
  
  # Clean variable names
  # set to camelCase
  features$V2 <- tocamel(features$V2)
  ## tocamel() removes punctuation so this line is not required> features$V2 <- gsub("[[:punct:]]" ,"",features$V2)
  # change 't' at the start of the word to 'time'
  features$V2 <- gsub("^t" ,"time",features$V2)
  # change 'angleT' or 'anglet' at the start of the word to 'angleTime'
  features$V2 <- gsub("^angle[Tt]" ,"angleTime",features$V2)
  # change 'f' at the start of the word to 'freq'
  features$V2 <- gsub("^f" ,"freq",features$V2)
  # change 'BodyBody' or 'bodybody' in the word to 'Body'
  features$V2 <- gsub("[Bb]ody[Bb]ody" ,"Body",features$V2)
  
  
  # Read in list of Activities indexes and enum's 
  activityLabels <-
    read.table(
      "./UCI HAR Dataset/activity_labels.txt",
      quote = "\"",
      stringsAsFactors = FALSE
    )
  
  # Parse and merge the Test data sets *************************************************************
  # read test data file to a Dataframe
  testDatadf = read.table(
    "./UCI HAR Dataset/test/X_test.txt",
    quote = "\"",
    stringsAsFactors = FALSE
  )
  # assign column names to test data file (using names in "V2")
  names(testDatadf) = features$V2
  # read test Action data to a Dataframe
  testActionLabeldf = read.table(
    "./UCI HAR Dataset/test/y_test.txt",
    quote = "\"",
    stringsAsFactors = FALSE
  )
  # merge test actions with their activities labels
  testAction_activity <- full_join(testActionLabeldf, activityLabels)
  #assign column names to Action / Activity data set
  names(testAction_activity) = c("ActionId", "Activity")
  #read test Subject data to a Dataframe
  testSubjectdf = read.table(
    "./UCI HAR Dataset/test/subject_test.txt",
    quote = "\"",
    stringsAsFactors = FALSE
  )
  #assign column names to subject test file
  names(testSubjectdf) = c("subjectId")
  
  # Merge test data sets, Subject Id's from subject_test.txt, Activity Enum, measurement data
  allTestdata <-
    cbind(
      as.data.table(testSubjectdf),
      Activity = (testAction_activity$Activity),
      (testDatadf)
    )
  
  
  # Parse and merge the Training data sets *************************************************************
  #read train data file to a Dataframe
  trainDatadf = read.table(
    "./UCI HAR Dataset/train/X_train.txt",
    quote = "\"",
    stringsAsFactors = FALSE
  )
  #assign column names to test data file
  names(trainDatadf) = features$V2
  #read train Action data to a Dataframe
  trainActionLabeldf = read.table(
    "./UCI HAR Dataset/train/y_train.txt",
    quote = "\"",
    stringsAsFactors = FALSE
  )
  # merge train actions with their activities labels
  trainAction_activity <- full_join(testActionLabeldf, activityLabels)
  names(trainAction_activity) = c("ActionId", "Activity")
  #read train Subject data to a Dataframe
  trainSubjectdf = read.table(
    "./UCI HAR Dataset/train/subject_train.txt",
    quote = "\"",
    stringsAsFactors = FALSE
  )
  #assign column names to train data file
  names(trainSubjectdf) = c("subjectId")
  
  # Merge train data sets, Subject Id's from subject_test.txt, Activity Enum, measurement data
  allTraindata <-
    cbind(
      as.data.table(trainSubjectdf),
      Activity = (trainAction_activity$Activity),
      (trainDatadf)
    )
  
  # Merge Training and Test data sets into one table
  all_Data <- rbind(allTraindata, allTestdata)
  
  
  # Write out intem full Raw data set
  if(localDebug){ 
    # for debug output
    write.csv(all_Data, "all_data.csv")
    }
  
  # Create logical vector with grepl indicating columns which have mean() and std() in their name
  #   then create a character vector of only features with mean and standard deviation in their name
  feature_list <-
    as.character(features$V2[grepl('[Mm]ean|[Ss]td', features$V2)])
  
  # write out unshaped data
  write.csv(subset(all_Data, select = c("subjectId", "Activity", feature_list)), row.names =
              FALSE, file = "tidyUnsummarized.csv")
  
  # Melt data frame for reshaping (making subjectId, Activity as ID's 
  #   and the rest of the columns as variables )
  tidydf <-
    melt(
      all_Data,
      id = c("subjectId", "Activity"),
      measure.vars = feature_list,
      na.rm = TRUE
    )
  
  # Reshape into tidy data frame by mean using the reshape2 package
  tidydf <- dcast(tidydf,  Activity + subjectId ~ variable ,  mean)
  
  # Write out summary (mean) of tidy data
  write.csv(tidydf, row.names = FALSE, file =  "tidyMean.csv")

}

