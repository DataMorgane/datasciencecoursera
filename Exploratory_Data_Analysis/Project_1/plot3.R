
# Code constructing plot3.png

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

png("plot3.png", width = 480, height = 480)

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
       lwd=c(2.5,2.5,2.5))

dev.off()