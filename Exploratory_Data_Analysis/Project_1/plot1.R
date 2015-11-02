
# Code constructing plot1.png

data <- read.table("household_power_consumption.txt", 
                   skip = 66645, nrows = 2879, 
                   na.strings = "?", 
                   sep = ";", 
                   colClasses = c("character","character",rep("numeric",7)), 
                   col.names = c("Date","Time","Global_active_power",
                               "Global_reactive_power","Voltage",
                               "Global_intensity","Sub_metering_1",
                               "Sub_metering_2","Sub_metering_3"))

png("plot1.png", width = 480, height = 480)

hist(data$Global_active_power, 
     col = "salmon", 
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)")

dev.off()
