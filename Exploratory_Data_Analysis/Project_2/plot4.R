

# Across the United States, how have emissions from coal combustion-related 
# sources changed from 1999–2008?

# Reading the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Merging the two dataframes
data <- merge(x = NEI, y = SCC)

# Subsetting the rows related to coal combustion
data_coal <- data[data$EI.Sector == "Fuel Comb - Comm/Institutional - Coal"
                  | data$EI.Sector == "Fuel Comb - Industrial Boilers, ICEs - Coal"
                  | data$EI.Sector == "Fuel Comb - Electric Generation - Coal",]

emissions_coal_by_year <- by(data_coal$Emissions, data_coal$year, sum)

png("plot4.png", width = 480, height = 480)
barplot(emissions_coal_by_year,
        main = "Total emissions of PM2.5 related to coal combustion per year",
        xlab = "Year",
        ylab = "Emissions of PM2.5 (tons)",
        col = "salmon")
dev.off()


