---
title: "README document for Coursera Getting and Cleaning Data Project"
author: "mjpalacios"
date: "October 21, 2015"
output: html_document
---

##Purpose of this document
This document describes the contents of my GitHub repository for Coursera's
"Getting and Cleaning Data" course project and provides instructions on how to 
run the R script used to transform an input data set (University of California 
at Irvine's Human Activity Recognition) into a subset of averaged measurements 
grouped by subject and activity.

##References
1. Getting and Cleaning Data Course Project [Assignment Page](https://class.coursera.org/getdata-033/human_grading/view/courses/975117/assessments/3/submissions).

##Contents
This section describes the contents of this repository.

Filename         | Description
:-------         | :----------
README.md        | This file
Codebook.md      | Describes the variables (columns) in the output dataset
run_analysis.R   | R Script that implements the project's requirements
run_analysis.txt | Output file created by the R script, provided for validation purposes.

##Setup
Before running the script, the following has to be setup:

- The R Environment is installed. It can be either "plain vanilla R" or RStudio.
- Package "dplyr" has been installed. It does not have to be loaded, the script does that.
- The [original dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) has been downloaded as "UCI_HAR_Dataset.zip" and placed into the working directory of your R environment. Do not decompress the
file.

##Steps
To obtain the processed dataset, perform the following steps:

1\. Source the analysis function into R and run it in the R Console.

```r
source("<your default R working directory>/run_analysis.R")
run_analysis()
```
2\. Once the function has completed running, you will see one output file 
("run_analysis.txt") in your working directory.

```r
# Verify that output file is present
list.files(pattern="run_analysis.txt")

#Output
[1] "run_analysis.txt"
```

3\. To read the file into R, issue the following command in the R Console:

```r
# Read text file
result <- read.table("run_analysis.txt", header=TRUE)
```
