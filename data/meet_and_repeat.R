# Teemu Vahtola, 01.12.2022
# Assignment 5: Data Wrangling

# Read the data
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt",
                   sep = " ", header = T)

RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt",
                   sep = "\t", header = T)

# Take a look at the data sets
dim(BPRS); dim(RATS)
names(BPRS); names(RATS)
glimpse(BPRS)
glimpse(RATS)

# Convert categorical variables to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# Convert to long form, add variable "week" to BPRS and "Time" to RATS
BPRSL <-  pivot_longer(BPRS, cols = -c(treatment, subject),
                       names_to = "weeks", values_to = "bprs") %>%
  arrange(weeks)

RATSL <- pivot_longer(RATS, cols = -c(ID, Group), 
                      names_to = "WD",
                      values_to = "Weight") %>% 
  mutate(Time = as.integer(substr(WD, 3, 4))) %>%
  arrange(Time)

# Compare the variable names of the wide and long form tables
names(BPRS); names(BPRSL)
names(RATS); names(RATSL)

# Look at the structures, and create some brief summaries of the data to understand it better
str(BPRSL); str(RATSL)
glimpse(BPRSL)
glimpse(RATSL)

# Write the new long form data to files
write.table(RATSL, "data/ratsl.txt", append = F, sep = ",", dec = ".",
            row.names = T, col.names = T)

write.table(BPRSL, "data/bprsl.txt", append = F, sep = ",", dec = ".",
            row.names = T, col.names = T)