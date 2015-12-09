

# Have total emissions from PM2.5 decreased in the United States from 1999 to 
# 2008? Using the base plotting system, make a plot showing the total PM2.5 
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.

# Reading the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

emissions_by_year <- by(NEI$Emissions, NEI$year, sum)

png("plot1.png", width = 480, height = 480)
barplot(emissions_by_year,
        main = "Total emissions of PM2.5 per year",
        xlab = "Year",
        ylab = "Emissions of PM2.5 (tons)",
        col = "skyblue")
dev.off()



