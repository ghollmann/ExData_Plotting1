#---------------------------------------------------------------------------
# This script will read in a Household Power Consumption data file from the 
# UCI Machine Learning repository that contains:
#    Measurements of electric power consumption in one household with a one-minute 
#    sampling rate over a period of almost 4 years. Different electrical quantities 
#    and some sub-metering values are available."
# The results of this script is to produce a set of exploratory graphs for the time 
# period of February 1, 2007 and February 2, 2007. This histogram will be save to a
# file named plot4.png. In order to read in the entire file a minimum of 220 MB of 
# memory will be needed.
#
# Load Packages and get the Data
path<-getwd()
#install.packages("lubridate")
library(lubridate)
url <- "http://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip"
download.file(url, file.path(path, "household_power_comsumption.zip"))
unzip(zipfile = "household_power_comsumption.zip")
HPConsumption<-read.table(file="household_power_consumption.txt", sep=";", header=TRUE,
                          colClasses = c("factor","factor","numeric","numeric","numeric",
                                         "numeric","numeric","numeric","numeric"), na.strings="?")

# Get only the observations from dates February 1st and 2nd of 2007.  The date is in the format of d-m-y
HPConsumption$Date <- dmy(HPConsumption$Date)
HPConsumptionSub <- subset(HPConsumption, Date=="2007-2-1" | Date=="2007-2-2")
HPConsumptionSub$DateTime<-ymd_hms(paste(HPConsumptionSub$Date, HPConsumptionSub$Time, " "),
                                   tz=Sys.timezone())
# Create a layout for 4 plots with 2 per row.  Then produce the four plots and save to plot4.png
par(mfrow = c(2, 2))
plot(HPConsumptionSub$Global_active_power~HPConsumptionSub$DateTime, type="l" ,
     ylab="Global Active Power", xlab="")

plot(HPConsumptionSub$Voltage~HPConsumptionSub$DateTime, type="l" ,
     ylab="Voltage", xlab="datetime")

plot(HPConsumptionSub$DateTime, as.numeric(HPConsumptionSub$Sub_metering_1), type = "l", xlab="", 
     ylab="Energy sub metering")
points(HPConsumptionSub$DateTime, HPConsumptionSub$Sub_metering_2, type ="l", col = "red")
points(HPConsumptionSub$DateTime, HPConsumptionSub$Sub_metering_3, type ="l", col = "blue")
legend("topright", border="black", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col=c("black","red","blue"), lty=1)

plot(HPConsumptionSub$Global_reactive_power~HPConsumptionSub$DateTime, type="l" ,
     ylab="Global_reactive_power", xlab="datetime")
dev.copy(png, file = "plot4.png")
dev.off()
