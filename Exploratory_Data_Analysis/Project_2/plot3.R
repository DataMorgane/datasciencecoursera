

# Of the four types of sources indicated by the type (point, nonpoint, 
# onroad, nonroad) variable, which of these four sources have seen decreases 
# in emissions from 1999–2008 for Baltimore City? Which have seen increases in 
# emissions from 1999–2008? Use the ggplot2 plotting system to make a plot 
# answer this question.

library(ggplot2)

# Reading the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Subsetting data for Baltimore
NEI_Balt <- NEI[NEI$fips == "24510",]
NEI_Balt$type <- as.factor(NEI_Balt$type)

g <- ggplot(NEI_Balt, aes(x = year, y = Emissions)) + 
    geom_bar(stat = "identity") + 
    facet_wrap(~type) +
    labs(title = "Emissions of PM2.5 from different types of sources in Baltimore")

ggsave(file = "plot3.png")
