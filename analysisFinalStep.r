# Note That Turkey is considered in ASIA and not Europe. We'll
# also see the numbers when it is not included
# Now we can put thngs together
# source("myuefa.r")
# source("countriesAbbr.r") # I already saved datasets from these files

# The names of countries are from different sources so there will be some
# errors. I will not change any data. I will just copy sets from my data
# change what I copied and compare that with another copied set. I will take the
# best fit! Perhaps even use adist if no match can be found. The encoding of the
# files do not make it easy either.

# Africa <- data.frame(data.frame(readLines("Africa.txt", warn = FALSE), 
#                                 stringsAsFactors = FALSE)[-1,], 
#                      stringsAsFactors = FALSE)
# names(Africa) <- "Africa"
# Asia <- data.frame(data.frame(readLines("Asia.txt", warn = FALSE), 
#                               stringsAsFactors = FALSE)[-1,], 
#                    stringsAsFactors = FALSE)
# names(Asia) <- "Asia"
# Oceania <- data.frame(data.frame(readLines("Oceania.txt", warn = FALSE), 
#                                  stringsAsFactors = FALSE)[-1,], 
#                       stringsAsFactors = FALSE)
# names(Oceania) <- "Oceania"
# Europe <- data.frame(data.frame(readLines("Europe.txt", warn = FALSE), 
#                                 stringsAsFactors = FALSE)[-1,], 
#                      stringsAsFactors = FALSE)
# names(Europe) <- "Europe"
# South_America <- data.frame(data.frame(readLines("South_America.txt", warn = FALSE), 
#                                        stringsAsFactors = FALSE)[-1,], 
#                             stringsAsFactors = FALSE)
# names(South_America) <- "South_America"
# North_America <- data.frame(data.frame(readLines("North_America.txt", warn = FALSE), 
#                                        stringsAsFactors = FALSE)[-1,], 
#                             stringsAsFactors = FALSE)
# names(North_America) <- "North_America"

# Ran and saved.
# Now use dplyr to match each region with country abbreviations in
# wordCountries dataset

# mutatedWorldCountries <- worldCountries
# This allows us to merge sets
# names(mutatedWorldCountries) <- c("Country_Name", "Nationality") 
# UefaDataMutated <- dplyr::left_join(UefaData, mutatedWorldCountries)

# Now Get the rows with NA and put in correct country_Names myself
# unMatched <- UefaDataMutated[which(!complete.cases(UefaDataMutated)),"Nationality"]
# unMatched <- unique(unMatched)
# namesToMatch <- c("Uruguay", "Portugal", "Croatia", "Switzerland", "Chile", "Greece",
#                   "Netherlands", "Congo", "Paraguay", "Bulgaria", "United Kingdom", 
#                   "United Kingdom", "United Kingdom", "Nigeria", "Germany", "Madagascar",
#                   "Costa Rica", "Honduras", "Guinea", "Denmark", "South Africa",
#                   "Algeria", "Angola")
# # Checked the names of players with WAl as NAT and they are all welch. not from
# # Wattis & Futnuna. So I changed Scotland and Wales to United Kingdoms
# playersWithUnmatchedNat <- UefaDataMutated[UefaDataMutated$Nationality == "WAL",]$Name
# sideBySide <- data.frame(Nationality = unMatched, Country_Name = namesToMatch, 
#                          stringsAsFactors = FALSE)
# 
# 
# # Now Join them again
# UefaDataMutated2 <- UefaDataMutated
# for(i in which(!complete.cases(UefaDataMutated))){
#   ind = which(unMatched == UefaDataMutated[i, "Nationality"])
#   UefaDataMutated2[i,"Country_Name"] <- namesToMatch[ind]
# }

# Now Match by continent
# First row-bind all contienents and keep region identity
# bindConts <- function(A, B, C, D, E, G, vec = c("Africa", "Asia",
#                                                 "Europe", "North_America",
#                                                 "Oceania", "South_America")){
#   names(A) <- "Country_Name"
#   names(B) <- names(A)
#   names(C) <- names(A)
#   names(D) <- names(A)
#   names(E) <- names(A)
#   names(G) <- names(A)
#   
#   df <- rbind(A, B, C, D, E, G)
#   Region <- rep(vec, c(nrow(A), nrow(B), nrow(C), nrow(D), nrow(E), nrow(G)))
#   df <- cbind(df, Region)
#   names(df)[2] <- "Region"
#   return(df)
# }
# Countries_by_region <- bindConts(Africa, Asia, Europe, North_America, Oceania,
#                                  South_America)
# Countries_by_region[which(Countries_by_region$Country_Name == "Russia"),
#                     "Country_Name"] <- "Russian Federation"

# Now join (mutate) data to have regions
# BigUefaData <- dplyr::left_join(UefaDataMutated2, Countries_by_region)
# Looked over 3 missing values because of different names for 
# South Korea and Macedonia. I will manually input the region
# BigUefaData[which(!complete.cases(BigUefaData)),"Region"] <- c("Asia", "Europe",
#                                                              "Europe")

# Somehow the new data has more observations than the original one and I have no
# idea why. Yet when I did length(which(!is.element(BigUefaData$Name, UefaData$Name)))
# all Player names are matched in both data frames. Wow apparently some names
# were duplicated in the origina UEFA data which is fairly possible since UEFA
# sometimes put firstnames or nicknames... Either way I am happy with the data
# The new data is only 11 observations more than the original.
# I will now remove duplicates that were not in the original data but appeared
# in the new one!
# a <- data.frame(table(UefaData$Name)) # original duplicates
# b <- data.frame(table(BigUefaData$Name)) # duplicates in new data
# first check to make sure all duplicates from original are in mutated.
# then remove the difference... the frequency was 2 in all cases

# a <- a[which(a$Freq > 1),] # get names that appeared twice in orginal data
# b <- b[which(b$Freq > 1),] # get names that appeared twice in mutated data
# setdiff(a$Var1, b$Var1) #returns 0 so we are good.
# 
# toRemove <- setdiff(b$Var1, a$Var1) # These are the names that came out duplicated
# in our mutated data so we will remove one instance of each
# A quick observation made me realize that Cyprus was both in Asia and Europe
# vec <- NULL
# for(i in 1:length(toRemove)){
#   vec <- c(vec, which(BigUefaData == toRemove[i]))
# }

# A quick look at BigUefaData[vec,] shows that only Cyprus caused the problem
# Easy fix: I am going to remove Cyprus from the Asia data frame before joining.
# Cyprus occured at index 10. Removing Cyprus proved fairly critical. The whole
# script failed because of one entry and I do not know why.
# Suffices to modify BigUefaData
# indices = NULL # The indices without Asia as Cyprus's continent
# for(i in vec){
#   if(BigUefaData[i, "Region"] == "Asia"){
#     indices <- c(indices, i)
#   }
# }

## Now remove those indices from BigUefaData
# BigUefaData2 <- BigUefaData[-indices, ]

# BigUefaData2 <- dplyr::group_by(BigUefaData2, Region)
# region_Nbers <- dplyr::summarise(BigUefaData2, count = n())

# BigUefaData3 <- BigUefaData2 # Now we will exclue Turkey and Armenia from Asia
# EuroAsia <- which(BigUefaData3$Country_Name == "Turkey")
# EuroAsia <- c(EuroAsia, which(BigUefaData3$Country_Name == "Armenia"))
# BigUefaData3[EuroAsia, "Region"] <- "Europe"
# BigUefaData3 <- dplyr::group_by(BigUefaData3, Region)
# region_Nbers_EurAsia <- dplyr::summarise(BigUefaData3, count = n())

# Summarise by country
# BigUefaData4 <- dplyr::group_by(BigUefaData3, Country_Name)
# countByCountry <- dplyr::summarise(BigUefaData4, count = n())

# Now get GeoCode for each country.
# latsLongs <- sapply(countByCountry$Country_Name, ggmap::geocode)
# latsLongsdat <- matrix(unlist(latsLongs), ncol = 2, byrow = T)
# latsLongsdat <- data.frame(latsLongsdat, stringsAsFactors = FALSE)
# names(latsLongsdat) <- c("lon", "lat")
# latsLongsdat$Country_Name <- countByCountry$Country_Name
# # Fix latitude and longittude for Ivory coast and Macedonia
# toFix <- sapply(c("Ivory Coast", "Macedonia"), ggmap::geocode)
# toFix <- matrix(unlist(toFix), ncol = 2, byrow = T)
# toFix <- data.frame(toFix)
# names(toFix) <- c("lon", "lat")
# latsLongsdat[which(!complete.cases(latsLongsdat))[1], c("lon", "lat")] <- toFix[1,]
# latsLongsdat[which(!complete.cases(latsLongsdat))[1], c("lon", "lat")] <- toFix[2,]
# # Now add lon and lat columns to dataset
# BigUefaData5 <- dplyr::left_join(BigUefaData3, latsLongsdat)
# countByCountry <- dplyr::left_join(countByCountry, latsLongsdat)

# Just a quick function to determine cex
ln <- function(x){
  if(x < 20){
    return(1)
  } else {
    return(log(sqrt(x)))
  }
}

# cexVec <- sapply(countByCountry$count, ln)
# 
# pdf("TotalPlayerPerCountry.pdf")
# newmap <- rworldmap::getMap(resolution = "high")
# plot(newmap, main = "2014/2015 UCL Countries Represented", xlab = "", ylab = "")
# points(countByCountry$lon, countByCountry$lat, col = "red", pch = 20, 
#        bg = "blue", cex = cexVec)
# dev.off()