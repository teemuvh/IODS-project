# Teemu Vahtola, 21.11.2022
# IODS 2022 data wrangling assignment 2
# Data (student-mat.csv and student-por.csv) obtained from: 
# UCI Machine Learning Repository, Student Performance Data (incl. Alcohol consumption) 
# Url to original data: https://archive.ics.uci.edu/ml/datasets/Student+Performance

# Import dplyr and readr
library(dplyr)
library(readr)

# Read both data
math <- read.table("data/student-mat.csv",
                   sep=";",
                   header=TRUE)

por <- read.table("data/student-por.csv",
                  sep=";",
                  header=TRUE)

# Structure
str(math); str(por)
# Dimensions
dim(math); dim(por)

# columns that vary in the two data sets
free_cols <- c("failures", "paid", "absences", "G1", "G2", "G3")

# the rest of the columns are common identifiers used for joining the data sets
join_cols <- setdiff(colnames(por), free_cols)

# join the two data sets by the selected identifiers
math_por <- inner_join(math, por, by = join_cols, suffix=c(".math", ".por"))

# Structure of the new data
str(math_por)
# Dimensions of the new data
dim(math_por)

# Combine duplicated answers in the joined data
alc <- select(math_por, all_of(join_cols))
for(col_name in free_cols) {
  two_cols <- select(math_por, starts_with(col_name))
  first_col <- select(two_cols, 1)[[1]]
  if(is.numeric(first_col)) {
    alc[col_name] <- round(rowMeans(two_cols))
  } else {
    alc[col_name] <- first_col
  }
}

# new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# new logical column 'high_use', TRUE for students for which 'alc_use' is higher than 2
alc <- mutate(alc, high_use = alc_use > 2)

glimpse(alc)

# Write to file
write_csv(alc, "data/alc.csv")
