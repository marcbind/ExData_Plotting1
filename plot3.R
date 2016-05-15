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


# Convert Date+Time into POSIXlt for further processing
# Convert Sub_metering_1/2/3 into numeric, as we need it for this plot.
powr$DateTime <- dmy_hms(paste(powr$Date, powr$Time))
powr <- mutate(powr, Sub_metering_1 = as.numeric(Sub_metering_1),
                     Sub_metering_2 = as.numeric(Sub_metering_2),
                     Sub_metering_3 = as.numeric(Sub_metering_3))


# create the plot into png file
png(filename = "plot3.png",
    width = 480, height = 480, bg = "white")

# Build the frame, use pmax to allow for proper scaling
plot(powr$DateTime,
     pmax(powr$Sub_metering_1, powr$Sub_metering_2,
          powr$Sub_metering_3, na.rm=TRUE),
     xlab = "", ylab = "Energy sub metering", type = "n")

# add the 3 actual graphs, in different colors
points(powr$DateTime, powr$Sub_metering_1, col = "black", type = "l")
points(powr$DateTime, powr$Sub_metering_2, col = "red", type = "l")
points(powr$DateTime, powr$Sub_metering_3, col = "blue", type = "l")

# add the legend
legend("topright",
       c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col = c("black","red","blue"), lty = "solid")

# write the file out
dev.off()

# The End. Done.