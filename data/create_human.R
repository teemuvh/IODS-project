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



