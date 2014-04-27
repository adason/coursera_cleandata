### Tidy Data From Human Activity Recognition Using Smartphones Dataset ###
This is the project assignment for **Getting and Cleaning Data** [course](https://class.coursera.org/getdata-002) in coursera. The purpose of this projcet is to practice how to prepare tidy data that can be used for further statistical analyisis. In this project, we are asked to handle the [Human Activity Recognition Using Smartphones Dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). Here I presented my code and tidy data set to fulfill the course project.

### Instructions ###
You should create one R script called *run_analysis.R* that does the following. 

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

-------------------------------------------------------------------------------
### How to Run the Code ###
Just issue the following command

```{bash}
Rscript run_analysis.R
```

Make sure you have the origial dataset in the same directory and called "data/". 

### Files Included in This Folder ###
- CodeBook.md: desctiption about the features
- run_analysis.R: The complete code used to generate tidy data and the mean data
- combined_data.csv: tidy data including only "mean" and "std" from original dataset
- mean_combined_data.csv: average of each variable for each activity and each subject

### Notes ###
- Only feature name including "mean" and "std" are included. "meanFreq" is ignored.
- Use data.table to increase efficiency
