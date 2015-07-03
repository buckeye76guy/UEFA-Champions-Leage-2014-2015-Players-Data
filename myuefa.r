library(RCurl)
library(XML)

myUefa <- function(id){ # squad id
  # Make sure RCurl and XML are loaded
  id <- as.character(id) # Just making sure. you can enter a nber and be fine
  input <- paste0("http://www.uefa.com/uefachampionsleague/season=2015/clubs/club=",
                  id,"/squad/index.html")
  html <- getURL(input, followlocation = TRUE)
  doc <- htmlParse(html, asText = TRUE)
  text <- xpathSApply(doc, "//td[@class=\"l\"]", xmlValue)
  text
  # Find where "2013/14" starts and delete everything below. Keep coach of course
  # final text.
  fin_text <- text[-c(which(grepl("[0-9]+/[0-9]+", text))[1]:length(text))]
  # Turn it into a data frame.
  playerNamesInd <- seq(1,length(fin_text),2)
  playerNames <- fin_text[playerNamesInd]
  playerNationality <- fin_text[-playerNamesInd]
  uefadat <- data.frame(Name = playerNames, Nationality = playerNationality,
                        stringsAsFactors = FALSE)
  return(uefadat)
}

# Now I will go through each stat page and only get team ID
teamIds <- readLines("allids.txt", warn = FALSE)
teamIds <- gsub(" ", "", teamIds)
UefaData <- myUefa(teamIds[1])
for(i in 2:length(teamIds)){
  UefaData <- rbind(UefaData, myUefa(teamIds[i]))
}
