# Load in useful libraries
library(dplyr)
library (data.table)

#set working directory
setwd("/Users/cameliaguild/Projects/DataScientistsToolbox/Exploratory-Data-Analysis")

filename <- "exdata_dataset.zip"

# Download and unzip data files:
if (!file.exists(filename)) {
  fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL, filename, method="curl")
  unzip(filename)
}

# Read and create data table
temp <- read.table("./household_power_consumption.txt", header=TRUE, na.strings="?", stringsAsFactors = FALSE, sep=";")
temp$Date <- as.Date(temp$Date, format = "%d/%m/%Y")
pc <- temp[(temp$Date =="2007-02-01") | (temp$Date=="2007-02-02"),]

# Transform columns (i.e, declare data type)
pc$Global_active_power <- as.numeric(as.character(pc$Global_active_power))
pc$Global_reactive_power <- as.numeric(as.character(pc$Global_reactive_power))
pc$Voltage <- as.numeric(as.character(pc$Voltage))
pc$Sub_metering_1 <- as.numeric(as.character(pc$Sub_metering_1))
pc$Sub_metering_2 <- as.numeric(as.character(pc$Sub_metering_2))
pc$Sub_metering_3 <- as.numeric(as.character(pc$Sub_metering_3))

# Create a new column that combines date and time variables
# pc$Timestamp <- paste(pc$Date, pc$Time)
pc <- transform(pc, Timestamp=as.POSIXct(paste(Date, Time)), "%d/%m/%Y %H:%M:%S" )
names(pc)

# 
plot4 <- function(){
  par(mfrow=c(2,2))
  # plot 1
  plot(pc$Timestamp, pc$Global_active_power, type="l", xlab="", 
       ylab = "Global Active Power")
  # plot 2
  plot(pc$Timestamp, pc$Global_active_power, type="l", xlab="datetime",
       ylab="Voltage")
  # plot 3
  plot(pc$Timestamp, pc$Sub_metering_1, type="l", xlab="", 
       ylab = "Energy sub metering")
  lines(pc$Timestamp, pc$Sub_metering_2, col="red")
  lines(pc$Timestamp, pc$Sub_metering_3, col="blue")
  legend("topright", col=c("black", "red", "blue"), c("Sub_metering_1", 
        "Sub_metering_2", "Sub_metering_3"), lty=c(1,1), lwd=c(1,1), cex=0.5, bty="n")
  
  # plot 4
  plot(pc$Timestamp, pc$Global_reactive_power, type="l", xlab="datetime", 
       ylab = "Global_rective_power")
  
  # send output to png file
  dev.copy(png, file="plot4.png", width=480, height=480)
  dev.off()
  cat("Plot4.png has been saved in", getwd())
}
plot4()
