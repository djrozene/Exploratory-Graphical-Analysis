## Load libraries
library(dplyr)
library(data.table)

## remove all objects from memory to avoid confusion in the global enviornment.
rm(list = ls())

## Load data
## Zip archives are actually more a 'filesystem' with content metadata etc. 
## See help(unzip) for details. 
## Create a temp. file name (eg tempfile())
## Use download.file() to fetch the file into the temp. file
## Use unz() to extract the target file from temp. file
## Remove the temp file via unlink()
## dataframe has a header, nine columns separated with semicolon, missing values are coded as ? 
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
data<- read.table(unz(temp, "household_power_consumption.txt"), header=TRUE, sep=";", na.strings = "?", dec=".")
unlink(temp)

## convert the date variable to Date class using the as.Date(function)
data$Date <- as.Date(data$Date, format="%d/%m/%Y")

## The strptime command takes a string and converts it into a form that R can use for calculations.
data$time <- strptime(data$Time, "%Y-%m-%d")

##  Subset data from the dates 2007-02-01 and 2007-02-02. 
datasubset <- subset(data, subset=(Date >= "2007-02-01" & Date <= "2007-02-02"))

## Create a DateTime variable that combines date and time before plotting. 
datasubset$DateTime <- paste(datasubset$Date, datasubset$Time)
## Convert the datasubset$datetime to a date/time class before plotting.
datasubset$DateTime <- as.POSIXct(datasubset$DateTime)

## Plot 4
## par() R makes it easy to combine multiple plots into one overall graph.  Use the options
## mfrow=c(nrows, ncols) to create a matrix of nrows x ncols plots that are filled in by row,
## Note: mfcol=c(nrows, ncols) fills in the matrix by columns.
par(mfrow=c(2,2), mar=c(4,4,2,1), oma=c(0,0,2,0))

## with datasubset
with(datasubset, 
## generate plots
{
## Plot 1
  plot(Global_active_power ~ datasubset$DateTime, type="l", ylab="Global Active Power (kilowatts)", xlab="")
## Plot 2
  plot(Voltage ~ datasubset$DateTime, type="l", ylab="Voltage (volt)", xlab="")
## Plot 3
  plot(Sub_metering_1 ~ datasubset$DateTime, type="l", ylab="Global Active Power (kilowatts)", xlab="")
    ## Add lines and legend to the third plot
    lines(Sub_metering_2 ~ datasubset$DateTime, col='Red') 
    lines(Sub_metering_3 ~ datasubset$DateTime, col='Blue')
    legend("topright", col=c("black", "red", "blue"), lty=1, lwd=2, bty="n", legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
## plot 4
  plot(Global_reactive_power ~ datasubset$DateTime, type="l", ylab="Global Rective Power (kilowatts)", xlab="")
}
)

## Copy to PNG file
dev.copy(png, file="plot4.png", height=480, width=480)
dev.off()