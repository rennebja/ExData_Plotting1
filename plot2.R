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

png(file = "plot2.png")
with(my_data, plot(datetime, Global_active_power, 
                    ylab = "Global Active Power (kilowatts)", 
                    xlab = "", type = "l"))

dev.off()