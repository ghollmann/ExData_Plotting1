#---------------------------------------------------------------------------
# This script will read in a Household Power Consumption data file from the 
# UCI Machine Learning repository that contains:
#    Measurements of electric power consumption in one household with a one-minute 
#    sampling rate over a period of almost 4 years. Different electrical quantities 
#    and some sub-metering values are available."
# The results of this script is to produce a plot of 3 household energy sub metering
# meterics for the time period of February 1, 2007 and February 2, 2007.
# This plot will be save to a file named plot3.png. In order to read in the entire file
# a minimum of 220 MB or memory will be needed.
#
# Load Packages and get the Data
path<-getwd()
install.packages("lubridate")
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

# Produce the histogram and save as plot1.png

plot(HPConsumptionSub$DateTime, as.numeric(HPConsumptionSub$Sub_metering_1), type = "l", xlab="", 
     ylab="Energy sub metering")
points(HPConsumptionSub$DateTime, HPConsumptionSub$Sub_metering_2, type ="l", col = "red")
points(HPConsumptionSub$DateTime, HPConsumptionSub$Sub_metering_3, type ="l", col = "blue")
legend("topright", border="black", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),
       col=c("black","red","blue"), lty=1)
dev.copy(png, file = "plot3.png")
dev.off()
