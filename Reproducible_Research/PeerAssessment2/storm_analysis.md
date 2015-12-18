# Timeline and consequences of the major natural disasters in the USA from 1996 to 2011
Morgane Flauder  
December 16, 2015  

This document is an assignment for the Reproducible Research course (Johns Hopkins University) on Coursera.

This project use the U.S. National Oceanic and Atmospheric Administration's (NOAA) storm database from 1950 to 2011. This database tracks characteristics of major storms and weather events in the United States, including when and where they occur, as well as estimates of any fatalities, injuries, and property damage. The goal is to determine which types of events are the most harmful to the population health, and which types of events have the greatest economic consequences.

## Synopsis

In this project, I analyzed the consequences of different types of natural disasters between 1996 and 2011 in the 50 states of the USA. I chose to plot them on several timelines. These plots represent the number of fatalities, the number of injuries, the cost of property damage and the cost of crop damage by year for the deadliest and most exepensive types of natural disasters. I discovered that droughts are the most dangerous event for the crops, and that Hurricane Katrina was by far the most expensive natural disaster for these years. In terms of population health, tornadoes outbreaks leaves the more victims (injured or dead), especially the 2011 Super Outbreak. Floods are also very dangerous, and heat waves can be particularly deadly.

## Data Processing

First, let's upload some libraries, download the dataset and read the data.


```r
library(plyr)
library(outliers)

# Dowloading and reading the data
#download.file("https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2FStormData.csv.bz2",
#              "repdata-data-StormData.csv.bz2")

data <- read.csv("repdata-data-StormData.csv.bz2", na.strings = c("NA",""))
dim(data)
```

```
## [1] 902297     37
```

### Selection of the observations of interest

The [Storm Events Database section of the NOAA website](http://www.ncdc.noaa.gov/stormevents/details.jsp?type=eventtype) provides some details about the events types available in the database over time. In particular, between 1950 and 1955, only the tornadoes were recorded, then the thunderstorms and the hail were added. It's only from 1996 that all types of events were recorded. This means that an analysis of the types of events for all the dataset will be skewed in favor of tornadoes, thunderstorms and hail. Therefore, I chose to focus my analysis on the last 15 years of the dataset (1996-2011).

Since some events last several days, I chose the beginning date of the event as the reference date.


```r
####################################################
#  Selection of the records between 1996 and 2011  #
####################################################

# Date formatting
data$BGN_DATE <- as.Date(data$BGN_DATE, format = "%m/%d/%Y")

# Creation of a new dataset data_1996 with only the records from 1996
data_1996 <- data[data$BGN_DATE > "1996-01-01",]
```

I noticed that the dataset includes all the states of the USA, but also the territories and some marine region. I chose to focus my analysis on the 50 states of the USA (and the District of Columbia).


```r
######################
#  State subsetting  #
######################

states <- c("AK", "AL", "AR", "AZ", "CA", "CO", "CT", "DC", "DE", "FL", "GA",
            "HI", "IA", "ID", "IL", "IN", "KS", "KY", "LA", "MA", "MD", "ME",
            "MI", "MN", "MO", "MS", "MT", "NC", "ND", "NE", "NH", "NJ", "NM",
            "NV", "NY", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX",
            "UT", "VA", "VT", "WA", "WI", "WV", "WY")

data_1996 <- data_1996[data_1996$STATE %in% states,]

# Getting rid of the unused factors
data_1996 <- droplevels(data_1996)
```

### Creation of new events categories

The next step is to re-assign the events types. There are indeed 495 different categories (EVTYPE) of natural disasters in this dataset. The goal here is to reduce this number by grouping similar events.

I chose to create my own categories instead of using the 48 official categories available in the [National Weather Service instructions](https://d396qusza40orc.cloudfront.net/repdata%2Fpeer2_doc%2Fpd01016005curr.pdf). I kept some of those categories but aggregated some other. For example, I chose to combine the categories "Heat" and "Extreme Heat" to form a single category "Hot Weather". Therefore, I reduced the number of types of events to 30 (+ "Other") instead of 48.

I used regular expressions to select the EVTYPE factors and assign them to the new types of events.


```r
####################################
#  Creation of new EVENT category  #
####################################

data_1996$EVENT <- NA

# Delete "summary" rows
data_1996 <- data_1996[-grep("summary", data_1996$EVTYPE, ignore.case = TRUE),]

# All events related to mild movements of the sea
# Examples: high tide, rogue wave, rough surf, heavy seas, rip current
data_1996[grepl("tide|surf|seas$|current|rogue.*wave",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Tide/Waves/Current"

data_1996[grepl("avalanche",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Avalanche"

data_1996[grepl("fog",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Fog"

data_1996[grepl("smoke",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Smoke"

data_1996[grepl("dust",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Dust"

data_1996[grepl("erosion",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Erosion"

data_1996[grepl("flood|fld",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Flood"

data_1996[grepl("fire",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Fire"

# Different types of landslide (rock slides, mud slides)
data_1996[grepl("landslide|landslump|rock.*slide|mud.*slide",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Landslide"

data_1996[grepl("hail",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Hail"

# Rain and precipitations
data_1996[grepl("rain|precip",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Rain"

# Snow and ice related events
data_1996[grepl("snow|ice|sleet|icy|glaze",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Snow/Ice"

data_1996[grepl("wind",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Wind"

data_1996[grepl("lightning",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Lightning"

data_1996[grepl("tsunami",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Tsunami"

# Tsunami-like wave that can come with storms / hurricanes
data_1996[grepl("storm.*surge",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Storm Surge"

# Tsunami-like wave in inland lakes
data_1996[grepl("seiche",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Seiche"

data_1996[grepl("volcanic",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Volcanic Event"

data_1996[grepl("funnel.*cloud",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Funnel Cloud"

data_1996[grepl("tropical.*depression",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Tropical Depression"

data_1996[grepl("tropical.*storm",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Tropical Storm"

data_1996[grepl("hurricane",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Hurricane"

data_1996[grepl("coastal.*storm",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Coastal Storm"

# Landspouts and waterspouts are types of tornadoes
data_1996[grepl("tornado|landspout|waterspout",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Tornado"

# "tstm" is an abbreviation of thunderstorm
# We don't want the "non tstm wind" and "non-tstm wind" in the thunderstorm
# category
data_1996[!(!grepl("non.*tstm.*wind",
                   data_1996$EVTYPE,
                   ignore.case = T)
            - grepl("thunderstorm|tstm",
                    data_1996$EVTYPE,
                    ignore.case = T)),]$EVENT <- "Thunderstorm"

data_1996[grepl("blizzard|winter.*storm",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Blizzard"

data_1996[grepl("wet",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Wet Weather"

# All events related to hot weather
# Examples: heat wave, abnormal warmth, hot spell, record high,
# hyperthermia/exposure
data_1996[grepl("heat|hot|record.*high|warm|hyperthermia",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Hot Weather"

# All events related to dry weather
# Examples: abnormally dry, drought, record low rainfall
data_1996[grepl("drought|dry|low.*rainfall|driest",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Dry Weather"

# All event related to cold weather
# Examples: record cold, hard freeze, hypothermia/exposure, winther weather,
# first frost, cool spell
data_1996[grepl("cold|winter.*weather|wintry|cool|hypothermia|chill|freez|frost",
                data_1996$EVTYPE,
                ignore.case = TRUE),]$EVENT <- "Cold Weather"

# All the other events are put in the "Other" category
data_1996[is.na(data_1996$EVENT),]$EVENT <- "Other"
```

There is a small problem : some events belong in two categories, for example EVTYPE "excessive heat/drought" could be in the "Hot Weather" or in the "Dry Weather" category. It will be assign to the last category in the script, in this case it will be "Dry Weather". The order of the implementation is actually important. I had to make some choices here : for example, I think that a "freezing fog" belong more to the category "cold weather" than to the category "fog". However, these choices are my personal opinion and don't rely on a objective classification of the types of events.

### Computation of the cost of the property and crop damages

The next step is to compute the cost of the economic damages. Actually, there are two variables for each : a number, and a multiplicator factor (K for thousands, M for Millions, B for Billions). The goal is to create 2 new variables PROPERTY and CROP with the cost in dollars.


```r
#######################################
#  Computation of the economic costs  #
#######################################

data_1996$PROPERTY <- NA
data_1996$CROP <- NA

# Property cleaning
data_1996[!is.na(data_1996$PROPDMGEXP)
          & data_1996$PROPDMGEXP=="K",]$PROPERTY <- 1000 * data_1996[!is.na(data_1996$PROPDMGEXP)
                                                                     & data_1996$PROPDMGEXP=="K",]$PROPDMG
data_1996[!is.na(data_1996$PROPDMGEXP)
          & data_1996$PROPDMGEXP=="M",]$PROPERTY <- 1000000 * data_1996[!is.na(data_1996$PROPDMGEXP)
                                                                        & data_1996$PROPDMGEXP=="M",]$PROPDMG
data_1996[!is.na(data_1996$PROPDMGEXP)
          & data_1996$PROPDMGEXP=="B",]$PROPERTY <- 1000000000 * data_1996[!is.na(data_1996$PROPDMGEXP)
                                                                           & data_1996$PROPDMGEXP=="B",]$PROPDMG
data_1996[!is.na(data_1996$PROPDMGEXP)
          & data_1996$PROPDMGEXP=="0",]$PROPERTY <- data_1996[!is.na(data_1996$PROPDMGEXP)
                                                              & data_1996$PROPDMGEXP=="0",]$PROPDMG
data_1996[data_1996$PROPDMG==0,]$PROPERTY <- 0

# Crop cleaning
data_1996[!is.na(data_1996$CROPDMGEXP)
          & data_1996$CROPDMGEXP=="K",]$CROP <- 1000 * data_1996[!is.na(data_1996$CROPDMGEXP)
                                                                     & data_1996$CROPDMGEXP=="K",]$CROPDMG
data_1996[!is.na(data_1996$CROPDMGEXP)
          & data_1996$CROPDMGEXP=="M",]$CROP <- 1000000 * data_1996[!is.na(data_1996$CROPDMGEXP)
                                                                        & data_1996$CROPDMGEXP=="M",]$CROPDMG
data_1996[!is.na(data_1996$CROPDMGEXP)
          & data_1996$CROPDMGEXP=="B",]$CROP <- 1000000000 * data_1996[!is.na(data_1996$CROPDMGEXP)
                                                                           & data_1996$CROPDMGEXP=="B",]$CROPDMG
data_1996[data_1996$CROPDMG==0,]$CROP <- 0
```

### Outlier detection and deletion

The last preprocessing step is to check if there is any outlier that will mess with the analysis. For this purpose, I used the very simple "outlier" function from the "outliers" package. It will return the value with the largest difference between it and the sample mean.

I searched for outliers in the 4 variables of interest. Let's begin with PROPERTY.


```r
########################
#  Outliers detection  #
########################

# Possible outlier for PROPERTY
outlier(data_1996$PROPERTY)
```

```
## [1] 1.15e+11
```

That means a property damage of 115 billions of dollars, and it's a huge number. Let's check the REMARKS feature to verify if the value is coherent with the event described.


```r
as.character(data_1996[data_1996$PROPERTY==1.15e+11,]$REMARKS)
```

```
## [1] "Major flooding continued into the early hours of January 1st, before the Napa River finally fell below flood stage and the water receeded. Flooding was severe in Downtown Napa from the Napa Creek and the City and Parks Department was hit with $6 million in damage alone. The City of Napa had 600 homes with moderate damage, 150 damaged businesses with costs of at least $70 million."
```

We can see that there were at most 76 millions of dollars in damage in this event, which is very far from 115 billions. It is safe to assume that there was an error in this entry. I chose to delete it.


```r
# Removing PROPERTY outlier
data_1996 <- data_1996[!data_1996$PROPERTY==1.15e+11,]
```

I did the same process for the other variables INJURIES, FATALITIES and CROP, but I detected no significant outlier : the numbers were coherent with the REMARKS section.

## Results

### Selection of the worst types of natural disaster

First, let's check the 10 types of event that had the most fatalities, and then the most injuries.


```r
sort(by(data_1996$FATALITIES, data_1996$EVENT, sum), decreasing = TRUE)[1:10]
```

```
## data_1996$EVENT
##        Hot Weather            Tornado              Flood
##               2037               1513               1289
##          Lightning Tide/Waves/Current       Cold Weather
##                641                609                464
##       Thunderstorm               Wind           Blizzard
##                379                372                261
##          Avalanche
##                223
```


```r
sort(by(data_1996$INJURIES, data_1996$EVENT, sum), decreasing = TRUE)[1:10]
```

```
## data_1996$EVENT
##      Tornado        Flood  Hot Weather Thunderstorm    Lightning
##        20668         8509         7702         5119         4134
##     Blizzard         Wind         Fire     Snow/Ice    Hurricane
##         1677         1480         1457         1332          968
```

We can see that the 3 worst types of events in terms of population health are tornadoes, hot weather, and floods. The deadliest event is the hot weather, however tornadoes cause more victims overall (injuries and fatalities).

Let's do the same of the economic cost : the property damage and the crop damage (in billions of dollars).


```r
sort(by(data_1996$PROPERTY/1000000000, data_1996$EVENT, sum), decreasing = TRUE)[1:10]
```

```
## data_1996$EVENT
##      Hurricane    Storm Surge          Flood        Tornado           Hail
##      78.942098      47.833574      44.393096      24.617195      14.595207
##   Thunderstorm           Fire Tropical Storm           Wind       Snow/Ice
##       7.896976       7.753378       7.541862       5.428648       4.324735
```


```r
sort(by(data_1996$CROP/1000000000, data_1996$EVENT, sum), decreasing = TRUE)[1:10]
```

```
## data_1996$EVENT
##    Dry Weather          Flood      Hurricane   Cold Weather           Hail
##     13.3673810      6.2531512      4.7934308      2.7405265      2.4968225
##   Thunderstorm           Rain           Wind Tropical Storm    Hot Weather
##      1.0169356      0.7399098      0.6987358      0.5738700      0.4925885
```

First, we can see that the damage on properties is much more costly than the damage on crops. We can also see that different types of events affects the properties or the crops: hurricanes (and storm surges, which are associated to hurricanes) are extremely costly in terms of property, but a dry weather is the worst event for the crops.

I chose to analyze which events in particular were the deadliest and more expensive from 1996 to 2011. To do so, I summed the variables of interest by year, and represented them for the 3 or 4 worst types of event for each variable (FATALITIES, INJURIES, PROPERTY and CROP).

### Timeline of the deadliest natural disasters between 1996 and 2011

First, let's analyze the number of injuries and fatalities for the 3 deadliest types of events: tornadoes, hot weather, and floods.

The first step is to create a new dataframe with the sum of all injuries and fatalities for each year and each type of event. I used the "ddply" function from the "plyr" package to compute a result similar to the "by" function, but in the form of a dataframe instead of a list.


```r
data_sum_year <- ddply(data_1996,
                       .(EVENT, format(data_1996$BGN_DATE, "%Y")),
                       colwise(sum, c("FATALITIES", "INJURIES")))
colnames(data_sum_year) <- c("EVENT", "YEAR", "FATALITIES", "INJURIES")
```

We can now plot the results for the 3 deadliest types of events.


```r
par(mfrow = c(2,1))

# Plot of fatalities
plot(data_sum_year$YEAR[data_sum_year$EVENT == "Flood"],
     data_sum_year$FATALITIES[data_sum_year$EVENT == "Flood"],
     type = "l",
     ylim = c(0,700),
     xlab = "Year",
     ylab = "Number of fatalities",
     main = "Number of fatalities per year for the 3 deadliest types of event",
     col = "turquoise3",
     lwd = 2)
points(data_sum_year$YEAR[data_sum_year$EVENT == "Tornado"],
     data_sum_year$FATALITIES[data_sum_year$EVENT == "Tornado"],
     type = "l",
     col = "mediumorchid",
     lwd = 2)
points(data_sum_year$YEAR[data_sum_year$EVENT == "Hot Weather"],
       data_sum_year$FATALITIES[data_sum_year$EVENT == "Hot Weather"],
       type = "l",
       col = "orangered",
       lwd = 2)
text(1999, 550, "1999 heat wave", col = "orangered")
text(2006, 300, "2006 heat wave", col = "orangered")
text(1998, 170, "1998 Eastern\ntornado outbreak", col = "mediumorchid")
text(2008, 180, "2008 Super Tuesday\ntornado outbreak", col = "mediumorchid")
text(2010.7, 650, "2011 Super\nOutbreak", col = "mediumorchid")
legend("top",
       legend = c("Flood", "Tornado", "Hot Weather"),
       col = c("turquoise3", "mediumorchid", "orangered"),
       lty = c(1,1,1),
       lwd = 2)

# Plot of injuries
plot(data_sum_year$YEAR[data_sum_year$EVENT == "Flood"],
     data_sum_year$INJURIES[data_sum_year$EVENT == "Flood"],
     type = "l",
     ylim = c(0,7300),
     xlab = "Year",
     ylab = "Number of injuries",
     main = "Number of injuries per year for the 3 deadliest types of event",
     col = "turquoise3",
     lwd = 2)
points(data_sum_year$YEAR[data_sum_year$EVENT == "Tornado"],
       data_sum_year$INJURIES[data_sum_year$EVENT == "Tornado"],
       type = "l",
       col = "mediumorchid",
       lwd = 2)
points(data_sum_year$YEAR[data_sum_year$EVENT == "Hot Weather"],
       data_sum_year$INJURIES[data_sum_year$EVENT == "Hot Weather"],
       type = "l",
       col = "orangered",
       lwd = 2)
text(2000, 1700, "1999 heat wave", col = "orangered")
text(2006, 2000, "2006 heat wave", col = "orangered")
text(1998, 7000, "Texas 1998 Floods\n(Hurricane Madeline)", col = "turquoise3")
text(2010.7, 7000, "2011 Super\nOutbreak", col = "mediumorchid")
text(2008, 2200, "2008 Super Tuesday\ntornado outbreak", col = "mediumorchid")
text(1997.5, 2200, "1998 Eastern\ntornado outbreak", col = "mediumorchid")
text(1999.5, 2200, "1999 Oklahoma\ntornado outbreak", col = "mediumorchid")
legend("top",
       legend = c("Flood", "Tornado", "Hot Weather"),
       col = c("turquoise3", "mediumorchid", "orangered"),
       lty = c(1,1,1),
       lwd = 2)
```

![](https://rawgit.com/DataMorgane/datasciencecoursera/master/Reproducible_Research/PeerAssessment2/storm_analysis_files/figure-html/unnamed-chunk-14-1.svg)
<img src="https://rawgit.com/DataMorgane/datasciencecoursera/master/Reproducible_Research/PeerAssessment2/storm_analysis_files/figure-html/unnamed-chunk-14-1.svg">

We can see that even if the heat was the deadliest type of event between 1996 and 2011, it was from 2 separates heat waves in 1999 and 2006. However, the natural disaster that killed the most people in 1 year was the tornado category in 2011, due to the 2011 Super Outbreak.

Tornadoes are the natural disasters that causes the more injuries. That is particularly true in 2011, the year of the 2011 Super Outbreak. But we can also see that the Texas 1998 Floods that followed Hurricane Madeline left a very high number of injured people, even a little more than the tornadoes victims in 2011.


### Timeline of the most expensive natural disasters between 1996 and 2011

Let's do the same for the cost of property and crop damages, this time for the 4 worst types of events in each type of damage.

First, let's create a new dataframe with the sum of all the costs per year by type of event.


```r
damage_sum_year <- ddply(data_1996,
                       .(EVENT, format(data_1996$BGN_DATE, "%Y")),
                       colwise(sum, c("PROPERTY", "CROP")))
colnames(damage_sum_year) <- c("EVENT", "YEAR", "PROPERTY", "CROP")
```



```r
par(mfrow = c(2,1))

# Plot for property damage
plot(damage_sum_year$YEAR[damage_sum_year$EVENT == "Flood"],
     damage_sum_year$PROPERTY[damage_sum_year$EVENT == "Flood"]/1000000000,
     type = "l",
     ylim = c(0,53),
     xlab = "Year",
     ylab = "Property damage cost (billions of $)",
     main = "Property damage cost per year for the 4 most expensive types of event (property)",
     col = "turquoise3",
     lwd = 2)
points(damage_sum_year$YEAR[damage_sum_year$EVENT == "Hurricane"],
       damage_sum_year$PROPERTY[damage_sum_year$EVENT == "Hurricane"]/1000000000,
       type = "l",
       col = "green3",
       lwd = 2)
points(damage_sum_year$YEAR[damage_sum_year$EVENT == "Storm Surge"],
       damage_sum_year$PROPERTY[damage_sum_year$EVENT == "Storm Surge"]/1000000000,
       type = "l",
       col = "slateblue",
       lwd = 2)
points(damage_sum_year$YEAR[damage_sum_year$EVENT == "Tornado"],
       damage_sum_year$PROPERTY[damage_sum_year$EVENT == "Tornado"]/1000000000,
       type = "l",
       col = "mediumorchid",
       lwd = 2)
text(2006, 6, "2006\nMid-Atlantic flood", col = "turquoise3")
text(2005, 52, "2005\nHurricane Katrina", col = "green3")
text(1997, 8.5, "1997 Red\nRiver Flood", col = "turquoise3")
text(1999, 6.5, "1999\nHurricane Floyd\nHurricane Irene", col = "green3")
text(2004, 20.5, "2004\nHurricane Jeanne", col = "green3")
text(2008, 6.5, "2008\nHurricane Ike", col = "green3")
text(2010.5, 12, "2011 Super\nOutbreak", col = "mediumorchid")
text(2010.5, 18, "2011 Mississippi\nRiver floods", col = "turquoise3")
legend("topleft",
       legend = c("Flood", "Hurricane", "Storm Surge", "Tornado"),
       col = c("turquoise3", "green3", "slateblue", "mediumorchid"),
       lty = c(1,1,1,1),
       lwd = 2)

# Plot for crop damage
plot(damage_sum_year$YEAR[damage_sum_year$EVENT == "Flood"],
     damage_sum_year$CROP[damage_sum_year$EVENT == "Flood"]/1000000000,
     type = "l",
     ylim = c(0,3),
     xlab = "Year",
     ylab = "Crop damage cost (billions of $)",
     main = "Crop damage cost per year for the 4 most expensive types of event (crop)",
     col = "turquoise3",
     lwd = 2)
points(damage_sum_year$YEAR[damage_sum_year$EVENT == "Hurricane"],
       damage_sum_year$CROP[damage_sum_year$EVENT == "Hurricane"]/1000000000,
       type = "l",
       col = "green3",
       lwd = 2)
points(damage_sum_year$YEAR[damage_sum_year$EVENT == "Cold Weather"],
       damage_sum_year$CROP[damage_sum_year$EVENT == "Cold Weather"]/1000000000,
       type = "l",
       col = "hotpink",
       lwd = 2)
points(damage_sum_year$YEAR[damage_sum_year$EVENT == "Dry Weather"],
       damage_sum_year$CROP[damage_sum_year$EVENT == "Dry Weather"]/1000000000,
       type = "l",
       col = "orange",
       lwd = 2)
text(1999, 2.5, "The Drought of 1998-2002", col = "orange")
text(2006, 2.5, "2006 heat wave", col = "orange")
text(2008, 1.7, "2008\nMidwest floods", col = "turquoise3")
text(2010, 1.4, "2010 Minnesota\nWisconsin Flood", col = "turquoise3")
text(2005, 2.1, "2005\nHurricane Katrina", col = "green3")
text(1999, 1.6, "1999\nHurricane Floyd\nHurricane Irene", col = "green3")
legend("topright",
       legend = c("Flood", "Hurricane", "Cold Weather", "Dry Weather"),
       col = c("turquoise3", "green3", "hotpink", "orange"),
       lty = c(1,1,1,1),
       lwd = 2)
```

![](storm_analysis_files/figure-html/unnamed-chunk-16-1.svg?raw=true)

First, we can see that Hurrican Katrina was by very far the most expensive natural disaster of these years, with 50 billions dollars from the hurricane and close to 40 billions dollars from the storm surge that went with it. Hurricanes in general are very expensive in terms of property, with Hurricane Jeanne in 2004, Hurricane Floyd and Irene in 1999, and Hurricane Ike in 2008. Floods are also very expensive, with the 1997 Red River Flood and the 2006 Mid-Atlantic Flood. There was also a lot of damage in 2011 due to the 2011 Super outbreak (tornadoes) and the floods it caused (the heavy rains caused the Mississippi River to overflow).

Most of the damage on crops were due to dry weather, which can be linked to the 2006 heat wave and a drought from 1998 to 2002. Hurricanes are also bad for the agriculture, especially Hurricane Katrina in 2005, and Floyd and Irene in 1999.

The 2008 and 2010 floods were vere expensive in terms of crops damage, but not in property damage and there were no significant number of fatalities and injuries. This can be explained by the fact that thes floods occured in the Midwest, known as the nation's "breadbasket". There are indeed a lot of crops and agriculture in this region.
