## Load libraries
library(dplyr)
library(lubridate)

## Retrieve Data

if(!dir.exists("./data")){
     dir.create("./data")
     fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
     temp <- tempfile()
     download.file(fileURL, destfile = temp, method = "libcurl")
     unzip(temp, exdir = "./data")
     unlink(temp)
}

## Set up dataframe

my_data <- read.table("./data/household_power_consumption.txt", 
                      header = TRUE, sep = ";", na.strings = "?")
my_data$Date <- dmy(my_data$Date)
#my_data$Time <- hms(my_data$Time)
my_data <- filter(my_data, Date == "2007-02-01" | Date == "2007-02-02")
my_data <- mutate(my_data, datetime = paste(as.character(Date), Time))
my_data$datetime <- ymd_hms(my_data$datetime)

## Generate the plot


png(file = "plot4.png")
par(mfrow = c(2,2))
with(my_data, {
     plot(datetime, Global_active_power, 
                   ylab = "Global Active Power", 
                   xlab = "", type = "l")
     
     plot(datetime, Voltage, type = "l")
     
     plot(datetime, Sub_metering_1, 
          type = "l", ylab = "Energy sub metering", xlab = "")
     lines(datetime, my_data$Sub_metering_2, col = "red")
     lines(datetime, my_data$Sub_metering_3, col = "blue")
     legend("topright", lty = c(1,1,1), col = c("black", "red","blue"), 
            legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
     plot(datetime, Global_reactive_power, type = "l")
})

dev.off()