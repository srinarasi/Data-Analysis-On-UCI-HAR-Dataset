Data-Analysis-On-UCI-HAR-Dataset
================================

The script run_analysis.R does the following:

* Merges the training and the test sets to create one data set.

* Extracts only the measurements on the mean and standard deviation for each measurement

* Uses descriptive activity names to name the activities in the data set

* Appropriately labels the data set with descriptive activity names.

* Creates a second, independent tidy data set with the average of each variable for each activity and each subject.



When the file is sourced, it prints some info to the user and calls <pre><code>startProcessing</code></pre> with the file name. 

It then calls 
<pre><code>MergeAndLabelData</code></pre> 
to merge and label the data as required and passes it to 
<pre><code>processData</code></pre> 
for adding per subject per activity data.
