# Creating Choropleth maps
library(choroplethr)
library(choroplethrMaps)
library(choroplethrAdmin1)
notValidCountriesInd <- which(!is.element(tolower(countByCountry$Country_Name), 
                                        get_admin1_countries()))
notValidCountries <- countByCountry$Country_Name[notValidCountriesInd]

validNames <- c("republic of the congo", "ivory coast", "south korea",
                "macedonia", "russia", "republic of serbia", 
                "united states of america")
choroplethCountryData <- countByCountry[,c("Country_Name", "count")]
for(i in 1:length(notValidCountriesInd)){
  choroplethCountryData[notValidCountriesInd[i],"Country_Name"] <- validNames[i]
}
choroplethCountryData$Country_Name <- tolower(choroplethCountryData$Country_Name)
# 

## Countries checked and corrected
names(choroplethCountryData) <- c("region", "value")

# Instead of having black spots I will have other countries set at 0, not NA
allCountries <- data.frame(region = get_admin1_countries(), stringsAsFactors = F)
allCountries <- dplyr::left_join(allCountries, choroplethCountryData)
allCountries[which(!complete.cases(allCountries)), "value"] <- 0
allCountries[155, "region"] <- "republic of congo" # It seems the names differ

g <- country_choropleth(choroplethCountryData,
                   "2014/2015 UCL Countries Represented",
                   num_colors=9)
Country with at least 20 players
countriesMore <- which(allCountries[,"value"] >= 20)
countriesMore <- allCountries$region[countriesMore]

pdf("NA Choropleth Map Of Countries Represented2.pdf", width = 11)
g <- country_choropleth(allCountries, "2014/2015 UCL Countries Represented",
                        num_colors = 9) # I could use the zoom feature to only
# map countries on a specific continent
print(g)
dev.off()