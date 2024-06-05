# preprocess.R
library(dplyr)
library(DBI)
library(RSQLite)

# Load the data
data <- read.csv("./data.csv")

# Select only the necessary columns and filter by year range
data <- data %>%
  select(crashYear, region, crashSeverity, weatherA, latitude, longitude, fatalCount) #%>%
  #filter(crashYear >= 2020)

# Convert categorical columns to factors
data$region <- as.factor(data$region)
data$crashSeverity <- as.factor(data$crashSeverity)
data$weatherA <- as.factor(data$weatherA)

# Create a SQLite database and save the preprocessed data
con <- dbConnect(RSQLite::SQLite(), "./crash_data.sqlite")
dbWriteTable(con, "home_crash_data", data, overwrite = TRUE)

data <- dbGetQuery(con, "SELECT * FROM home_crash_data")

# Calculate total crashes
total_crashes <- data %>%
  group_by(crashYear) %>%
  summarize(total_crashes = n())

# Calculate top regions per year
top_regions <- data %>%
  group_by(region) %>%
  summarize(total_crashes = n()) %>%
  arrange(desc(total_crashes)) %>%
  slice_head(n = 3)

# Calculate total crashes by region per year
total_crashes_by_region <- data %>%
  group_by(crashYear, region) %>%
  summarize(total_crashes = n())

# Get the distinct regions sorted in ascending order
regions <- data %>%
  distinct(region) %>%
  pull(region) %>%
  sort()

#get the distinct years sorted is ascending order
years <- data %>%
  distinct(crashYear) %>%
  pull(crashYear) %>%
  sort()


# Store the results in new tables
dbWriteTable(con, "total_crashes", total_crashes, overwrite = TRUE)
dbWriteTable(con, "total_crashes_by_region", total_crashes_by_region, overwrite = TRUE)
dbWriteTable(con, "top_regions", top_regions, overwrite = TRUE)
dbWriteTable(con, "regions", data.frame(region = regions), overwrite = TRUE)
dbWriteTable(con, "years", data.frame(crashYear = years), overwrite = TRUE)

#update the regions, removing the word region
dbExecute(con, "UPDATE total_crashes_by_region SET region = REPLACE(region, ' Region', '')")
dbExecute(con, "UPDATE top_regions SET region = REPLACE(region, ' Region', '')")
dbExecute(con, "UPDATE regions SET region = REPLACE(region, ' Region', '')")

# Disconnect from the database
dbDisconnect(con)


dbGetQuery(con, "SELECT region, sum(total_crashes) total_crashes FROM total_crashes_by_region WHERE crashYear between 2020 and 2022 GROUP BY region")

#delete empty row from region table
dbExecute(con, "DELETE FROM home_crash_data WHERE region = ''")

#update the regions, removing the word region
dbExecute(con, "UPDATE total_crashes_by_region SET region = REPLACE(region, ' Region', '')")
