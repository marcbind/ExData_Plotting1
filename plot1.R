#
library(dplyr)
library(lubridate)
library(graphics)
library(grDevices)

# Go to the data location
# or comment out and run the script in the directory with the
# unzipped data file "household_power_consumption.txt"
# setwd("~/Training/Coursera/Exploratory-Project1")

# Read in with least processing (due to the size)
powrraw <- read.csv2("household_power_consumption.txt",
                     colClasses = "character", as.is=TRUE)

# Convert the "Date" into standardized format, then
# remove all but 1st/2nd February 2007
powr <- powrraw %>%
        filter((dmy(Date) == "2007-02-01") | (dmy(Date) == "2007-02-02"))


# Now work on the plot.
# Convert Global_active_power into numeric, as we need it for this plot.
powr <- mutate(powr, Global_active_power = as.numeric(Global_active_power))


# create the plot into png file
png(filename = "plot1.png",
    width = 480, height = 480, bg = "white")

hist(powr$Global_active_power, col = "red",
     xlab = "Global Active Power (kilowatts)",
     main = "Global Active Power")

# write the file out
dev.off()

# The End. Done.