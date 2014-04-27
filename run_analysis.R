# Describe this code

###########################
# Load required libraries #
###########################
library(data.table)



############################
## Some pre-process seting #
############################

# Turn on/off developement mode
dev_mode <- FALSE

# Set to nonegitive number under development mode
# Only nrows of rows in the whole dataset will be read under development mode.
nrows <- ifelse(dev_mode, 100L, -1L)

# Set the project directory prefix
prefix <- paste(getwd(), "data", sep = "/")


##################################################
# Read in commom info for train and test dataset #
##################################################

# Read feature names from file
col_names <- read.table(paste(prefix, "features.txt", sep = "/"), as.is = TRUE)$V2

# Set the reles to filter feature names
col_with_mean <- grep(".+mean\\(\\).+", col_names)
col_with_std <- grep(".+std\\(\\).+", col_names)
col_keep <- c(col_with_mean, col_with_std)

# Activity labels
activity_labels <- read.table(paste(prefix, "activity_labels.txt", sep = "/"),
                              col.names = c("value", "name"))
activity_labels$name <- sapply(activity_labels$name, tolower)




#######################################################################
########### Define functions to read data #############################
# The following functions take variable "type" and return a data.table.
# Type sholbe be either "train" or "test" to incicate the location of
# data you are reading.
######################################################################

# This function will read the original X data.
# 1. Only subset of colume indes that is defined in "col_keep" will be kept.
# Other columns are discarded.
# 2. subject_id will be read from the file and combined into the x data table.
read_x_data <- function(type){
    # Read original X data and filter only
    x_data <- read.table(paste(prefix, type, paste0("X_", type, ".txt"), sep = "/"),
                         nrows = nrows, strip.white = TRUE,
                         col.names = col_names, check.names = FALSE)
    # keep subsets that is defined eralier
    x_data <- data.table(x_data[, col_keep])

    # Read subject ID and combine into x_data
    subject_id <- read.table(paste(prefix, type, paste0("subject_", type, ".txt"), sep = "/"),
                             nrows = nrows, colClasses = "character")
    x_data[, subject_id:=subject_id$V1]

    x_data
}

# This function will read the original y data.
# The y value will be named as "activity", and the numerical categoracal
# representations will be changed to characters descriving the activiry.
read_y_data <- function(type){
    # Read original Y data
    y_data <- read.table(paste(prefix, type, paste0("y_", type, ".txt"), sep = "/"),
                         nrows = nrows, col.names = c("activity"))

    # map the activity values to the activity names
    y_data$activity <- plyr::mapvalues(y_data$activity, from = activity_labels$value,
                                to = activity_labels$name)

    data.table(y_data)
}



#############################################################
# The main process. Execute to read the train and test data #
#############################################################

cat("Reading X trainning data...\n")
x_train <- read_x_data("train")
cat("Reading X testing data...\n")
x_test <- read_x_data("test")
cat("Reading Y trainning data...\n")
y_train <- read_y_data("train")
cat("Reading Y testing data...\n")
y_test <- read_y_data("test")

# Merge x and y into the same table.
# Combine train and test data set.
cat("Processing data...\n")
cat("Merging training and testing dataset and merging X and Y...\n")
combined_data <- rbind(cbind(x_train, y_train), cbind(x_test, y_test))

# This part will remove some unwanted characters in column names
# replace "()-" with "." and "-" with "."
symbol_clean <- function(chr){
    chr <- gsub("\\(\\)-", "_", chr)
    chr <- gsub("-", "_", chr)
}
setnames(combined_data, sapply(colnames(combined_data), symbol_clean))

# Save the combined table to file.
cat("Saving tidy data...\n")
write.csv(combined_data,
          file = paste(prefix, "combined_data.csv", sep = "/"),
          quote = FALSE, row.names = FALSE)

# Clean up data during the process. Not needed anymore
# rm(list = ls()[-which(ls() == "combined_data")])



############################################################################
######################## Average Over Subjects #############################
# Finally, take average of each variable for each activity and each subject.
############################################################################
cat("\n\n")
cat("Taknig average...\n")
mean_combined_data <- combined_data[, lapply(.SD, mean), by = "subject_id,activity"]
cat("Saving average to file...\n")
write.csv(mean_combined_data,
          file = paste(prefix, "mean_combined_data.csv", sep = "/"),
          quote = FALSE, row.names = FALSE)
