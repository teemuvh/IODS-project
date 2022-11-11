# Teemu Vahtola, 11.11.2022, IODS22 Assignment 2: Data Wrangling.

# Task 1.

# read the data
lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

# Task 2.

# Explore the structure and dimensions of the data
dim(lrn14)
# The data has a dimensionality of 183x60 meaning that the data consists
# of 183 rows and 60 columns

# Look at the structure of the data
str(lrn14)
# The structure shows that lrn14 is stored as a dataframe object with 183 observations
# of 60 variables. It also shows that all the other variables are stored as integer values
# except for the last row, gender, that is stored as character strings. And, of course,
# it quickly reveals us the names of the columns in the data.

# Task 3.

lrn14$attitude <- lrn14$Attitude / 10
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
lrn14$deep <- rowMeans(lrn14[, deep_questions])
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
lrn14$surf <- rowMeans(lrn14[, surface_questions])
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
lrn14$stra <- rowMeans(lrn14[, strategic_questions])

# Keep the columns we want to have in the resulting data 
# (i.e., gender, age, attitude, deep, stra, surf and points)
# Import dplyr
library(dplyr)

# Choose what we want to keep
keep_columns <- c("gender","Age","attitude", "deep", "stra", "surf", "Points")

# Create a new dataset with the columns we want to keep
learning2014 <- lrn14[, keep_columns]

# Fix the column names so all are lowercase
colnames(learning2014)[2] <- "age"
colnames(learning2014)[7] <- "points"

# Filter out the samples where exam points is 0
learning2014 <- filter(learning2014, points > 0)

str(learning2014)
# Now the data has 166 observation and 7 variables.

# Write csv-file to the data directory
library(tidyverse)
write_csv(learning2014, "data/learning2014.csv")

# Finally, test that we can read the data again
learning14_data <- read_csv("data/learning2014.csv")
str(learning14_data)
head(learning14_data)

# Seems to work.
