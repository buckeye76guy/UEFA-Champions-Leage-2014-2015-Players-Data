# Now use Xpath to get list abbreviation to all countries!
library(RCurl)
library(XML)

input <- "http://www.worldatlas.com/aatlas/ctycodes.htm"
html <- getURL(input, followlocation = TRUE)
doc <- htmlParse(html, asText = TRUE)

fullNames <- xpathSApply(doc, "//td[@class=\"cell01\"]",xmlValue)
fullNames <- gsub("\n", "", fullNames)
abbr3L <- xpathSApply(doc, "//td[@class=\"cell03\"]", xmlValue)
abbr3L <- gsub("\n", "", abbr3L)

worldCountries <- data.frame(Name = fullNames, UNabbr = abbr3L, 
                             stringsAsFactors = FALSE)