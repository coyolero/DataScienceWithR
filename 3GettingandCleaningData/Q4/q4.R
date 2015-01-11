
setwd("~\\GitHub\\DataScienceWithR\\3GettingandCleaningData\\Q4")
getwd()


# # # # # # # 
# Question 1
# The American Community Survey distributes downloadable data about United States communities. 
# Download the 2006 microdata survey about housing for the state of Idaho using download.file() from here:
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv
# 
# and load the data into R. The code book, describing the variable names is here:
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf
# 
# Apply strsplit() to split all the names of the data frame on the characters "wgtp". 
# What is the value of the 123 element of the resulting list?

# "" "15"
# "w" "15"
# "15"
# "wgt" "15"

urlData <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
urlCodeBook <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf"
filePath <- file.path("data", "housingIdaho.csv")

if(!file.exists(filePath))
{
    download.file(urlData, destfile = filePath) 
    download.file(urlCodeBook, destfile = file.path("housingIdaho.pdf"),mode = "w" )
}

myDf <- read.csv(filePath)
dfNames <- names(myDf)

strsplit(dfNames,"wgtp")[123]
# [[1]]
# [1] ""   "15"



# # # # # # # 
# Question 2
# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Remove the commas from the GDP numbers in millions of dollars and average them. What is the average?
# 
# Original data sources: http://data.worldbank.org/data-catalog/GDP-ranking-table
# 377652.4
# 379596.5
# 381668.9
# 387854.4

urlData <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"

filePath <- file.path("data", "grossdomesticproduct.csv")

if(!file.exists(filePath))
{
    download.file(urlData, destfile = filePath) 
}

getwd()
myDf <- read.csv(filePath, stringsAsFactors = FALSE, skip=5, head=FALSE)
names(myDf)
head(myDf,200)
total <- myDf$V5

total <- total[!is.na()]

library(stringr)

# Only the rows that matters
myDf$V2 <- as.numeric(myDf$V2)
myDf <- myDf[!is.na(myDf$V2),]
myDf
myDf$V5 <- gsub(",", "", myDf$V5)
myDf
myDf$V5 <- str_trim(myDf$V5)
myDf
myDf$V5 <- as.numeric(myDf$V5)
myDf
mean(myDf$V5)

# [1] 377652.4


# # # # # # # 
# Question 3
# In the data set from Question 2 what is a regular expression that would allow you to count the number of countries whose name begins with "United"? Assume that the variable with the country names in it is named countryNames. 
# How many countries begin with United?
#
# grep("^United",countryNames), 3
# grep("^United",countryNames), 4
# grep("*United",countryNames), 5
# grep("United$",countryNames), 3

myDf
grep("^United",myDf$V4, value = TRUE)
# [1] "United States"        "United Kingdom"       "United Arab Emirates"


# # # # # # # 
# Question 4
# Load the Gross Domestic Product data for the 190 ranked countries in this data set:
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv
# 
# Load the educational data from this data set:
#     
#     https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv
# 
# Match the data based on the country shortcode. Of the countries for which the end of the fiscal year is available, how many end in June?
# 
# Original data sources:
#     http://data.worldbank.org/data-catalog/GDP-ranking-table
# http://data.worldbank.org/data-catalog/ed-stats
# 16
# 7
# 13
# 8

grossDomesticProduct <- "data//grossdomesticproduct.csv"
educationalData <- "data//educationalData.csv"

# grossDomesticProduct
gdpDf <- read.csv(filePath, stringsAsFactors = FALSE, skip=5, head=FALSE)
gdpDf$V2 <- as.numeric(gdpDf$V2)
gdpDf <- gdpDf[!is.na(gdpDf$V2),]
head(gdpDf,50)

# educational Data
edDf <- read.csv(educationalData)
names(edDf)
head(edDf,2)
head(edDf,50)

edDf2 <- edDf[,c(1,2,10)]
head(edDf2,10)

length(grep("Fiscal year",edDf2$Special.Notes,value = TRUE))
length(grep("[Ff]iscal year",edDf2$Special.Notes,value = TRUE))
length(grep("[Ff]iscal [Yy]ear(.*)[Jj]une",edDf2$Special.Notes,value = TRUE))
#> [1] 13

grep("[Ff]iscal [Yy]ear(.*)[Jj]une",edDf2$Special.Notes,value = TRUE)


# Question 5
# You can use the quantmod (http://www.quantmod.com/) package to get historical stock prices for publicly traded companies on the NASDAQ and NYSE. Use the following code to download data on Amazon's stock price and get the times the data was sampled.
# 
# library(quantmod)
# amzn = getSymbols("AMZN",auto.assign=FALSE)
# sampleTimes = index(amzn) 
# 
# How many values were collected in 2012? How many values were collected on Mondays in 2012?
# 251,51
# 250, 47
# 252, 47
# 252, 50

install.packages("quantmod")

library(quantmod)
amzn = getSymbols("AMZN", auto.assign=FALSE)
sampleTimes = index(amzn) 
sampleTimes


install.packages("lubridate")
library(lubridate)

sampleTimes <- ymd(sampleTimes)

sampleTimes2 <- sampleTimes[year(sampleTimes) == 2012]
length(sampleTimes2)
length(sampleTimes2[weekdays(sampleTimes2) == "lunes"])

weekdays(sampleTimes2[1])
             sampleTimes2[1]

