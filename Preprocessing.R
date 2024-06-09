# preprocess.R
library(dplyr)
library(DBI)
library(RSQLite)

# Load the data
#data <- read.csv("./data.csv")

# Select only the necessary columns and filter by year range
#data <- data %>%
#  select(crashYear, region, crashSeverity, weatherA, latitude, longitude, fatalCount) #%>%
  #filter(crashYear >= 2020)

# Convert categorical columns to factors
#data$region <- as.factor(data$region)
#data$crashSeverity <- as.factor(data$crashSeverity)
#data$weatherA <- as.factor(data$weatherA)

# Create a SQLite database and save the preprocessed data
con <- dbConnect(RSQLite::SQLite(), "./crash_data.sqlite")
#dbWriteTable(con, "crash_data", data, overwrite = TRUE)

data <- dbGetQuery(con, "SELECT * FROM crash_data")

# Calculate total crashes
total_crashes <- data %>%
  group_by(crashYear) %>%
  summarize(total_crashes = n())

# Calculate total crashes by region per year
total_crashes <- data %>%
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

#get distinct crash severities
crashSeverity <- data %>%
  distinct(crashSeverity) %>%
  pull(crashSeverity) %>%
  sort()

#get distinct weather conditions
weather <- data %>%
  distinct(weatherA) %>%
  pull(weatherA) %>%
  sort()


# Store the results in new tables
dbWriteTable(con, "total_crashes", total_crashes, overwrite = TRUE)
dbWriteTable(con, "regions", data.frame(region = regions), overwrite = TRUE)
dbWriteTable(con, "years", data.frame(crashYear = years), overwrite = TRUE)
dbWriteTable(con, "crashSeverity", data.frame(crashSeverity = crashSeverity), overwrite = TRUE)
dbWriteTable(con, "weather", data.frame(weather = weather), overwrite = TRUE)

#update the regions, removing the word region
dbExecute(con, "UPDATE total_crashes_by_region SET region = REPLACE(region, ' Region', '')")
dbExecute(con, "UPDATE regions SET region = REPLACE(region, ' Region', '')")
dbExecute(con, "UPDATE crash_data SET weatherA = 'Unknown' where weatherA = 'Null'")
dbExecute(con, "CREATE TABLE fatal_count_by_region AS
SELECT region, SUM(fatalCount) AS total_fatal_count
FROM crash_data
GROUP BY region;")
dbExecute(con, "CREATE TABLE average_speed_limit_by_region AS
SELECT region, round(AVG(speedLimit)) AS average_speed_limit
FROM crash_data
GROUP BY region;")
dbExecute(con, "CREATE TABLE total_crashes_holiday_region AS
SELECT region, holiday, count(*) as total_crashes FROM crash_data where holiday != '' group by region, holiday")


dbExecute(con, "UPDATE crash_data SET vehicleTypes = TRIM(
    CASE WHEN carStationWagon > 0 THEN 'Sedan ' ELSE '' END ||
    CASE WHEN bus > 0 THEN 'Bus ' ELSE '' END ||
    CASE WHEN taxi > 0 THEN 'Taxi ' ELSE '' END ||
    CASE WHEN truck > 0 THEN 'Truck ' ELSE '' END ||
    CASE WHEN motorcycle > 0 THEN 'Motorcycle ' ELSE '' END ||
    CASE WHEN bicycle > 0 THEN 'Bicycle ' ELSE '' END ||
    CASE WHEN schoolBus > 0 THEN 'School ' ELSE '' END ||
    CASE WHEN suv > 0 THEN 'SUV ' ELSE '' END ||
    CASE WHEN train > 0 THEN 'Train ' ELSE '' END ||
    CASE WHEN vanOrUtility > 0 THEN 'Van ' ELSE '' END ||
    CASE WHEN otherVehicleType > 0 THEN 'Other ' ELSE '' END
);")


# Disconnect from the database
dbDisconnect(con)

#print the columns of 
colnames(data)

dbListTables(con)
#Unknown


dbGetQuery(con, "SELECT replace(region, ' Region', '') region, crashYear, replace(crashSeverity, ' Crash', '') crashSeverity, weatherA, COUNT(*) total_crashes FROM crash_data GROUP BY region, crashYear, crashSeverity, weatherA")
dbGetQuery(con, "SELECT crashyear, crashSeverity, light, region, speedLimit, weatherA as weather, NumberOfLanes, roadSurface, tlaName, crashLocation1, crashLocation2, longitude, latitude FROM crash_data")
dbGetQuery(con, "SELECT * from vehicle_totals")
#delete empty row from region table
dbExecute(con, "DROP TABLE total_crashes_holiday_region")

#update the regions, removing the word region
dbExecute(con, "UPDATE total_crashes_by_region SET region = REPLACE(region, ' Region', '')")


dbExecute(con, "CREATE TABLE total_crashes AS 
                SELECT region, crashYear, crashSeverity, weatherA AS weather, 
                light, speedLimit, vehicleTypes AS vehicleType, COUNT(*) total_crashes 
                FROM crash_data 
                GROUP BY region, crashYear, crashSeverity, weatherA, light, speedLimit, vehicleTypes")