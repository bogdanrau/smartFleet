body <- dashboardBody(
    tags$head(tags$link(rel = "stylesheet", type = "text/css", href="smartFleet.css")),
    source("assets/ui/carInfo.R", local = TRUE)[1]
    # source("assets/ui/agencyOverview.R", local = TRUE)[1]
#         tabItems(
#             tabItem(tabName="agencyOverview", source("assets/ui/agencyOverview.R", local = TRUE)[1]),
#             tabItem(tabName="carInfo", source("assets/ui/carInfo.R", local = TRUE)[1])
#         )
)