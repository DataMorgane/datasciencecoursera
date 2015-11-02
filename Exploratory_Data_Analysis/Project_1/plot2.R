
# Code constructing plot2.png

data <- read.table("household_power_consumption.txt", 
                   skip = 66645, nrows = 2879, 
                   na.strings = "?", 
                   sep = ";", 
                   colClasses = c("character","character",rep("numeric",7)), 
                   col.names = c("Date","Time","Global_active_power",
                                 "Global_reactive_power","Voltage",
                                 "Global_intensity","Sub_metering_1",
                                 "Sub_metering_2","Sub_metering_3"))


data$Time <- strptime(paste(data$Date, data$Time), 
                      format = "%d/%m/%Y %H:%M:%S")

png("plot2.png", width = 480, height = 480)

plot(x = data$Time, 
     y = data$Global_active_power, 
     type = "l", 
     xlab = "", 
     ylab = "Global Active Power (kilowatts)", 
     col="darkorchid4")

dev.off()

