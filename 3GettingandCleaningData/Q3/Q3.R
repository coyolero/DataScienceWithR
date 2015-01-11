
# # # # # # # #
# Question 1
# ==========
# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# 
# and load the data into R. The code book, describing the variable names is here:
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# 
# Create a logical vector that 
# 1. identifies the households 
# 2. on greater than 10 acres 
# 3. who sold more than $10,000 worth of agriculture products. 
# 4. Assign that logical vector to the variable agricultureLogical. 
# 5. Apply the which() function like this to identify the rows of the data frame where the logical vector is TRUE.
# which(agricultureLogical) What are the first 3 values that result?
# 59, 460, 474
# 403, 756, 798
# 125, 238,262
# 153 ,236, 388

setwd("~\\GitHub\\DataScienceWithR\\3GettingandCleaningData\\Q3")

# Downloads the file.
urlData <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
urlCodeBook <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf"
if(!file.exists(file.path("data", "housingIdaho.csv")))
{
 download.file(urlData, destfile = file.path("data", "housingIdaho.csv")) 
 download.file(urlCodeBook, destfile = file.path("housingIdaho.pdf"),mode = "w" )
}


filePath <- file.path("data", "housingIdaho.csv")

# Reads the file.
myDf <- read.csv(filePath, stringsAsFactors = FALSE)

agricultureLogical <- myDf$ACR >= 3 & myDf$AGS >= 6

head(myDf[which(agricultureLogical),],3)
# R:/ The row numbers
# 125, 238,262

# # Load the objects
# library(data.table)
# library(dplyr)

# houses <- tbl_df(myDf)
# class(myDf)
# class(houses)
# # Removes the unused DF
# remove(myDf)
# 
# agricultureLogical <- 
#     houses %>%
#     select(SERIALNO,ACR, AGS) %>%
#     filter(ACR == 3, AGS == 6)

# 2. Greater than 10 acres 
# 3. who sold more than $10,000 worth of agriculture products. 


# # # # # # # #
# Question 2
# Using the jpeg package read in the following picture of your instructor into R
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg
# 
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data? 
#(some Linux systems may produce an answer 638 different for the 30th quantile)
#
# -15259150 -10575416
# 10904118 -594524
# -15259150 -594524
# -16776430 -15390165

picturePath <- file.path("data", "picture.jpg")
pictureUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
if(!file.exists(picturePath))
{
    download.file(pictureUrl, destfile = picturePath, mode = "wb") 
}

install.packages("jpeg")

library(jpeg)

myImg <- readJPEG(picturePath, native = TRUE)

quantile(myImg, c(0.3,0.8))
#   30%       80% 
#   -15259150 -10575416


# # # # # # # #
# Question 3
# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Load the educational data from this data set:
# 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# 
# 1. Match the data based on the country shortcode. How many of the IDs match? 
# 2. Sort the data frame in descending order by GDP rank (so United States is last). 
# 3. What is the 13th country in the resulting data frame?
# 
# Original data sources:
# http://data.worldbank.org/data-catalog/GDP-ranking-table
# http://data.worldbank.org/data-catalog/ed-stats
#
# 234, St. Kitts and Nevis
# 189, Spain
# 190, Spain
# 189, St. Kitts and Nevis
# 190, St. Kitts and Nevis
# 234, Spain

dtGrossDomesticProduct <- 

if(!file.exists(picturePath))
{
    download.file(pictureUrl, destfile = picturePath, mode = "wb") 
}


# Question 4
# What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?
# 133.72973, 32.96667
# 23, 30
# 32.96667, 91.91304
# 23, 45
# 23.966667, 30.91304
# 30, 37
# Question 5
# Cut the GDP ranking into 5 separate quantile groups. Make a table versus Income.Group. How many countries are Lower middle income but among the 38 nations with highest GDP?
# 12
# 0
# 3
# 5
