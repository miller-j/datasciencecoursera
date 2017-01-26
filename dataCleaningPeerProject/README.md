---
title: "Getting and Cleaning Data Course Project"

output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```


========================================

Course project deliverables for the Coursera course [Getting and Cleaning Data](https://www.coursera.org/learn/data-cleaning/home/welcome)

## Installation
* Check the [Dependencies](#Dependencies) section to make sure the required packages are installed
* Create a directory for this project, henceforth called `dataCleaningPeerProject`
* Download the script `run_analysis.R` to `dataCleaningPeerProject` 
* Download the raw data from <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> to `dataCleaningPeerProject` and unzip it. You can delete the zip file after this step.
  Your directory structure should look like this now (only shows 2 levels deep):
 

```{r eval = FALSE}
|----- UCI HAR Dataset
|   |----- README.txt
|   |----- activity_labels.txt
|   |----- features.txt
|   |----- features_info.txt
|   |----- test
|   |----- train
|
|----- run_analysis.R
```


## Dependencies
The script `run_analysis.R` depends on the libraries:

* `data.table`
* `dplyr`
* `reshape2`
* `rapportools`

## Running the analysis     
* Change the working directory in R to the installation directory (called `dataCleaningPeerProject` in the [Installation](#Installation) section).  
* Source the script `run_analysis.R` in R: `source("run_analysis.R")`
* Execute the function `run_analysis` with no arguments: `run_analysis()`
  Two datasets will be written to the working directory: `tidyUnsummarized.csv`and `tidyMean.csv`  


## Codebook
Information about the datasets is provided in `CodeBook.md`.     

## Code 
The code contains detailed commments explaining the steps in which the original data was transformed to `tidyUnsummarized.csv`and `tidyMean.csv` .

### Code Overview:
* The action data, user data and measurement data are merged for each dataset, test data / training data.  
* The test dataset and the training dataset are then merged to a single dataset for subseting of the 86 `mean` and `std` features, written as `tidyUnsummarized.csv`.
* The subset data is then `melt`ed by `Activity` and `subjectId`
* The data is then reshaped with `dcast` appling a `mean` function to sumarrize the data into `tidyMean.csv`


