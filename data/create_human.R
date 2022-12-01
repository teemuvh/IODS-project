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

write.table(human, "data/human.txt", append = FALSE, sep = ",", dec = ".",
            row.names = TRUE, col.names = TRUE)



# *** ASSIGNMENT 5: DATA WRANGLING (29.11.2022) ***
human_new <- read.table("data/human.txt",
                      sep=",", header = T)

str(human_new); dim(human_new)
# The data has 195 observations and 19 variables.
# The goal of the collected data is to represent development of a country in a more
# diverse manner than only by economic growth. Thus, the data consists of other variables as well,
# such as variables related to gender inequality, life expectancy, education, etc.
# The variables are:
# hdi.rank: Human Development Index Rank
# country: Country
# hdi: Human Development Index
# life.exp: Life Expectancy at Birth
# edu.exp: Expected Years of Education
# edu.mean: Mean Years of Education
# gni: Gross National Income per Capita
# gni-hdi rank: GNI per Capita Rank Minus HDI Rank
# gii.rank: Gender Inequality Index Rank
# gii: Gender Inequality Index
# maternal.mortality.ratio: Maternal Mortality Ratio
# ado.birth.rate: Adolescent Birth Rate
# parli.f: Percent Representation in Parliament
# edu.f: Population with Secondary Education (Female)
# edu.m: Population with Secondary Education (Male)
# labo.f: Labour Force Participation Rate (Female)
# labo.m: Labour Force Participation Rate (Male)
# edu.fm: Ratio of Female and Male Populations with Secondary Education
# labo.fm: Ratio of Labor Force Participation of Female and Male Populations in Each Country

library(stringr)

# look at the structure of the GNI column in 'human'
str(human_new$gni)

# GNI as numeric variable
human_new$gni <- str_replace(human_new$gni, pattern=",", replace ="") %>%
  as.numeric()

library(dplyr)
# Choose which columns to keep
keep <- c("country", "edu.fm", "labo.fm", "edu.exp", "life.exp", "gni", "maternal.mortality.ratio", "ado.birth.rate", "parli.f")
# Keep only those columns
human_new <- dplyr::select(human_new, one_of(keep))

# Remove rows with missing values
human_new <- filter(human_new, complete.cases(human_new))

# Remove the observations that relate to regions instead of countries (last 7 observations)
last <- nrow(human_new) - 7
human_new <- human_new[1:last, ]

# Define the row names of the data by the country names
rownames(human_new) <- human_new$country
# Drop country from columns:
# Choose which columns to keep
keep <- c("edu.fm", "labo.fm", "edu.exp", "life.exp", "gni", "maternal.mortality.ratio", "ado.birth.rate", "parli.f")
human_new <- dplyr::select(human_new, one_of(keep))

write.table(human_new, "data/human.txt", append = FALSE, sep = ",", dec = ".",
            row.names = TRUE, col.names = TRUE)
