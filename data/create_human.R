# Teemu Vahtola, 23.11.2022
# Assignment 4: data wrangling

library(readr)
library(tidyverse)

# Read "human development" and "gender inequality" datasets
human_dev <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gender_ineq <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# Explore the datasets
str(human_dev); str(gender_ineq)
dim(human_dev); dim(gender_ineq)

summary(human_dev); summary(gender_ineq)

# Print column names
colnames(human_dev)

# Rename variables
names(human_dev)[names(human_dev) == "HDI Rank"] <- "hdi.rank"
names(human_dev)[names(human_dev) == "Country"] <- "country"
names(human_dev)[names(human_dev) == "Human Development Index (HDI)"] <- "hdi"
names(human_dev)[names(human_dev) == "Life Expectancy at Birth"] <- "life.exp"
names(human_dev)[names(human_dev) == "Expected Years of Education"] <- "edu.exp"
names(human_dev)[names(human_dev) == "Mean Years of Education"] <- "edu.mean"
names(human_dev)[names(human_dev) == "Gross National Income (GNI) per Capita"] <- "gni"
names(human_dev)[names(human_dev) == "GNI per Capita Rank Minus HDI Rank"] <- "gni-hdi rank"

# Check that the names have changed
colnames(human_dev)

# Same for gender inequality data
colnames(gender_ineq)

names(gender_ineq)[names(gender_ineq) == "GII Rank"] <- "gii.rank"
names(gender_ineq)[names(gender_ineq) == "Country"] <- "country"
names(gender_ineq)[names(gender_ineq) == "Gender Inequality Index (GII)"] <- "gii"
names(gender_ineq)[names(gender_ineq) == "Maternal Mortality Ratio"] <- "maternal.mortality.ratio"
names(gender_ineq)[names(gender_ineq) == "Adolescent Birth Rate"] <- "ado.birth.rate"
names(gender_ineq)[names(gender_ineq) == "Percent Representation in Parliament"] <- "parli.f"
names(gender_ineq)[names(gender_ineq) == "Population with Secondary Education (Female)"] <- "edu.f"
names(gender_ineq)[names(gender_ineq) == "Population with Secondary Education (Male)"] <- "edu.m"
names(gender_ineq)[names(gender_ineq) == "Labour Force Participation Rate (Female)"] <- "labo.f"
names(gender_ineq)[names(gender_ineq) == "Labour Force Participation Rate (Male)"] <- "labo.m"

colnames(gender_ineq)

# Add ratio of f and m populations with secondary education, and
# ratio of labor force participation of f and m populations in each country
gender_ineq <- gender_ineq %>%
  mutate("edu.fm" = edu.f / edu.m,
         "labo.fm" = labo.f / labo.m)

human <- inner_join(human_dev, gender_ineq, by = "country")

write_csv(human, "data/human.csv")



# *** ASSIGNMENT 5: DATA WRANGLING (29.11.2022) ***
# Read the data we wrangled in the earlier exercise
# I am using the ready data, because for some reason, the script didn't read my data correctly
# If I read with read_csv, it returns 195 obs. and 19 variables, but with read.table it returns 164 obs. 19 variables and
# joins multiple countries into one cell for some reason...
human_new <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human1.txt",
                      sep=",", header = T)

str(human_new); dim(human_new)
# The data has 195 observations and 19 variables.
# The goal of the collected data is to represent development of a country in a more
# diverse manner than only by economic growth. Thus, the data consists of other variables as well,
# such as variables related to gender inequality, life expectancy, education, etc.
# The variables are:
# HDI.Rank: Human Development Index Rank
# Country: Country
# HDI: Human Development Index
# Life.Exp: Life Expectancy at Birth
# Edu.Exp: Expected Years of Education
# Edu.Mean: Mean Years of Education
# GNI: Gross National Income per Capita
# GNI.Minus.Rank: GNI per Capita Rank Minus HDI Rank
# GII.Rank: Gender Inequality Index Rank
# GII: Gender Inequality Index
# Mat.Mor: Maternal Mortality Ratio
# Ado.Birth: Adolescent Birth Rate
# Parli.F: Percent Representation in Parliament
# Edu2.F: Population with Secondary Education (Female)
# Edu2.M: Population with Secondary Education (Male)
# Labo.F: Labour Force Participation Rate (Female)
# Labo.M: Labour Force Participation Rate (Male)
# Edu2.FM: Ratio of Female and Male Populations with Secondary Education
# Labo.FM: Ratio of Labor Force Participation of Female and Male Populations in Each Country

library(stringr)

# look at the structure of the GNI column in 'human'
str(human_new$GNI)

# GNI as numeric variable
human_new$GNI <- str_replace(human_new$GNI, pattern=",", replace ="") %>%
  as.numeric()

library(dplyr)
# Choose which columns to keep
keep <- c("Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
# Keep only those columns
human_new <- dplyr::select(human_new, one_of(keep))

# Remove rows with missing values
human_new <- filter(human_new, complete.cases(human_new))

# Remove the observations that relate to regions instead of countries (last 7 observations)
last <- nrow(human_new) - 7
human_new <- human_new[1:last, ]

# Define the row names of the data by the country names
rownames(human_new) <- human_new$Country
# Drop country from columns:
# Choose which columns to keep
keep <- c("Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", "Mat.Mor", "Ado.Birth", "Parli.F")
human_new <- dplyr::select(human_new, one_of(keep))

write.table(human_new, "data/human.txt", append = FALSE, sep = ",", dec = ".",
            row.names = TRUE, col.names = TRUE)
