

# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == "24510") from 1999 to 2008? Use the base plotting system to make a 
# plot answering this question.

# Reading the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")


Baltimore_emissions_by_year <- by(NEI$Emissions[NEI$fips == "24510"], 
                                  NEI$year[NEI$fips == "24510"], 
                                  sum)

png("plot2.png", width = 480, height = 480)
barplot(Baltimore_emissions_by_year,
        main = "Total emissions of PM2.5 per year in Baltimore City",
        xlab = "Year",
        ylab = "Emissions of PM2.5 (tons)",
        col = "springgreen")
dev.off()
