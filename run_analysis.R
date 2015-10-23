#run_analysis.R
#Tidy up the Human Activity Recognition dataset from University of California at Irvine's Machine Learning Repository

suppressPackageStartupMessages(library(dplyr))

run_analysis_internal <- function (har_zip ) {
  
  #
  # Intro. Identify individual files within the .zip file
  #
  
  trn_s_file <- "UCI HAR Dataset/train/subject_train.txt"
  trn_X_file <- "UCI HAR Dataset/train/X_train.txt"
  trn_y_file <- "UCI HAR Dataset/train/y_train.txt" 
  tst_s_file <- "UCI HAR Dataset/test/subject_test.txt"
  tst_X_file <- "UCI HAR Dataset/test/X_test.txt"
  tst_y_file <- "UCI HAR Dataset/test/y_test.txt" 
  lbl_file   <- "UCI HAR Dataset/features.txt"
  act_file   <- "UCI HAR Dataset/activity_labels.txt"
  
  #
  # Step 1. Merge the training and the test sets to create one data set
  #
  
  #
  # 1a - Read train set (subject, X, y), "join" by row position
  #
  
  trn_s_df   <- read.csv(unz(har_zip, trn_s_file), header = FALSE, sep = "")
  trn_X_df   <- read.csv(unz(har_zip, trn_X_file), header = FALSE, sep = "")
  trn_y_df   <- read.csv(unz(har_zip, trn_y_file), header = FALSE, sep = "")
  trn_df     <- bind_cols(trn_s_df, trn_X_df, trn_y_df)
  
  #
  # 1b - Rinse and repeat for test set
  #
  
  tst_s_df   <- read.csv(unz(har_zip, tst_s_file), header = FALSE, sep = "")
  tst_X_df   <- read.csv(unz(har_zip, tst_X_file), header = FALSE, sep = "")
  tst_y_df   <- read.csv(unz(har_zip, tst_y_file), header = FALSE, sep = "")
  tst_df     <- bind_cols(tst_s_df, tst_X_df, tst_y_df)

  #
  # 1c - Create single data set from training and test data sets
  #
  
  full_df    <- rbind(trn_df, tst_df)
  
  #
  # 1d -  Get column labels, beautify them, assign them to data frame
  #
  
  feat_df    <- read.csv(unz(har_zip, lbl_file), header = FALSE, sep = "")
  names(full_df) <- c("subject", gsub("[(),-]", "", sapply(feat_df[2], tolower)), "activity")
  names(full_df) <- gsub("bodybody", "body", names(full_df))
  
  #
  # Step 2. Extract only the measurements on the mean and standard deviation for each measurement
  #         while keeping the subject and activity which will be needed later for grouping
  #
  
  view_cols  <- grep("^((subject|activity)|[tf].*(std|mean)[xyz]?)$", names(full_df))
  view_df    <- tbl_df(full_df[view_cols])
  
  # 
  # Step 3. Use descriptive activity names to name the activities in the data set
  #
  
  act_df     <- read.csv(unz(har_zip, act_file), header = FALSE, sep = "")
  view_df$activity <- sapply(view_df$activity, function(x) {as.character(act_df[x, 2])})
  
  #
  # Step 4. Appropriately label the data set with descriptive variable names 
  #
  
  # Done already as part of step 1d, not messing with this
  
  #
  # Step 5. From the data set in step 4, create a second, independent tidy data set with 
  #         the average of each variable for each activity and each subject
  #
  
  grp_df     <- group_by(view_df, subject, activity)
  result     <- summarize_each(grp_df, funs(mean), matches("body|grav"))
  write.table(result, file = "run_analysis.txt", row.names = FALSE)
  return(result)
}

#
# run_analysis
# Set up and validate file locations, then call run_analysis_internal to perform the actual analysi 
#

run_analysis <- function() {
  #
  # Set up environment
  #
  
  har_zip    <- "UCI_HAR_Dataset.zip"
  
  if ( !file.exists(har_zip) ) {
    stop("Can't find input dataset \"UCI_HAR_Dataset.zip\"")
  }
  
  run_analysis_internal(har_zip)  
}