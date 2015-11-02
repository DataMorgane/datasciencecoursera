
# Code constructing plot4.png

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

png("plot4.png", width = 480, height = 480)

par(mfrow = c(2,2))

# Top left plot

plot(x = data$Time, 
     y = data$Global_active_power, 
     type = "l", 
     xlab = "", 
     ylab = "Global Active Power", 
     col="darkorchid4")

# Top right plot

plot(x = data$Time,
     y = data$Voltage,
     xlab = "datetime",
     ylab = "Voltage",
     type = "l",
     col = "olivedrab")

# Bottom left plot

colors_plot = c("grey30", "firebrick", "cornflowerblue")

plot(x = data$Time,
     y=data$Sub_metering_1, 
     type="l", 
     col = colors_plot[1], 
     xlab = "", 
     ylab = "Energy Sub Metering",
     lwd = 1.5)

points(x = data$Time, 
       y=data$Sub_metering_2, 
       type="l", 
       col = colors_plot[2],
       lwd = 1.5)

points(x = data$Time, 
       y=data$Sub_metering_3, 
       type="l", 
       col = colors_plot[3],
       lwd = 1.5)

legend("topright",
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
       col = colors_plot,
       lty=c(1,1,1), 
       lwd=c(2.5,2.5,2.5),
       bty = "n")

# Bottom right plot

plot(x = data$Time,
     y = data$Global_reactive_power,
     type = "l",
     xlab = "datetime",
     ylab = "Global_reactive_power",
     col = "navy")

dev.off()

