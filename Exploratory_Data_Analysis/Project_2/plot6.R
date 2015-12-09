

# Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?


# Reading the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subsetting data for Baltimore and Los Angeles
NEI_comp <- NEI[NEI$fips == "24510"
                | NEI$fips == "06037",]

NEI_comp$fips[NEI_comp$fips == "24510"] <- "Baltimore"
NEI_comp$fips[NEI_comp$fips == "06037"] <- "Los Angeles"

# Merging the two dataframes
data <- merge(x = NEI_comp, y = SCC)

# Subsetting the rows related to vehicles sources
data_vehicle <- data[data$EI.Sector == "Mobile - On-Road Diesel Heavy Duty Vehicles"
                     | data$EI.Sector == "Mobile - On-Road Diesel Light Duty Vehicles"
                     | data$EI.Sector == "Mobile - On-Road Gasoline Heavy Duty Vehicles"
                     | data$EI.Sector == "Mobile - On-Road Gasoline Light Duty Vehicles",]


g <- ggplot(data_vehicle, aes(year, Emissions, fill = fips)) + 
    geom_bar(stat="identity", position = "dodge") + 
    scale_fill_brewer(palette = "Set1") +
    labs(title = "Comparison of PM2.5 emissions from motor vehicles in Baltimore and Los Angeles")

ggsave(file = "plot6.png")