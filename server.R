source("global.R")

shinyServer(function(input, output, session) {
    
    smartFleetConnect()
    
    source("functions/urlParser.R", local = TRUE)
    source("assets/server/carInfo.R", local = TRUE)
    source("assets/server/agencyOverview.R", local = TRUE)
    
})