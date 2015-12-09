

# How have emissions from motor vehicle sources changed from 1999–2008 in 
# Baltimore City?

# Reading the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subsetting data for Baltimore
NEI_Balt <- NEI[NEI$fips == "24510",]

# Merging the two dataframes
data <- merge(x = NEI_Balt, y = SCC)

# Subsetting the rows related to vehicles sources
data_vehicle <- data[data$EI.Sector == "Mobile - On-Road Diesel Heavy Duty Vehicles"
                     | data$EI.Sector == "Mobile - On-Road Diesel Light Duty Vehicles"
                     | data$EI.Sector == "Mobile - On-Road Gasoline Heavy Duty Vehicles"
                     | data$EI.Sector == "Mobile - On-Road Gasoline Light Duty Vehicles",]

emissions_vehicle_by_year <- by(data_vehicle$Emissions, data_vehicle$year, sum)

png("plot5.png", width = 480, height = 480)
barplot(emissions_vehicle_by_year,
        main = "Total emissions of PM2.5 related to motor vehicles\nin Baltimore per year",
        xlab = "Year",
        ylab = "Emissions of PM2.5 (tons)",
        col = "grey")
dev.off()