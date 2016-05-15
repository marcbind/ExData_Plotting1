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
powr$DateTime <- dmy_hms(paste(powr$Date, powr$Time))
# Convert Sub_metering_1/2/3 into numeric, as we need it for this plot.
powr <- mutate(powr, Sub_metering_1 = as.numeric(Sub_metering_1),
               Sub_metering_2 = as.numeric(Sub_metering_2),
               Sub_metering_3 = as.numeric(Sub_metering_3))
# Convert Global_active_power into numeric, as we need it for this plot.
powr <- mutate(powr, Global_active_power = as.numeric(Global_active_power))
# Convert Voltage into numeric, we use it for yet another plot
powr <- mutate(powr, Voltage = as.numeric(Voltage))
# Convert Global_reactive_power to numeric, more plots coming
powr <- mutate(powr, Global_reactive_power = as.numeric(Global_reactive_power))


# create the plot into png file
png(filename = "plot4.png",
    width = 480, height = 480, bg = "white")

# We want 2 x 2 layout.
par(mfcol = c(2,2))

# Top-left plot
plot(powr$DateTime, powr$Global_active_power, type = "l",
     ylab = "Global Active Power", xlab = "")


# Build the bottom-left plot.
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
       col = c("black","red","blue"), lty = "solid", bty = "n")


# This is the top-right plot
with(powr, plot(DateTime, Voltage, type = "l", xlab = "datetime"))


# This is the bottom-right plot
with(powr, plot(DateTime, Global_reactive_power,
                type = "l", xlab = "datetime"))


# write the file out
dev.off()

# The End. Done.