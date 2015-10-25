fluidRow(
    column(width = 12,
           selectizeInput("agency", label = 'Select an agency:', choices = departments, selected = "CSU, Sacramento")
           ),
    column(width = 12,
        valueBox(width = 3,
                 value = textOutput("agencyAverageCo2e", inline = TRUE),
                 subtitle = 'Average CO2e / mi (g)',
                 icon = icon("dashboard")),
        valueBox(width = 3,
                 value = textOutput("agencyAvgCo2e10", inline = TRUE),
                 subtitle = 'Average CO2e / 10yr (tons)',
                 icon = icon("area-chart")),
        valueBox(width = 3,
                 value = textOutput("agencyAvgCo2e100", inline = TRUE),
                 subtitle = 'Average CO2e / 100k mi (tons)',
                 icon = icon("line-chart")),
        valueBox(width = 3,
                 value = textOutput("agencyTotalCo2e100", inline = TRUE),
                 subtitle = 'Total CO2e (2014) (tons)',
                 icon = icon("bar-chart"))
    ),
    column(width = 12,
           box(width = 12,
               title = 'Fleet Information',
               status = 'primary',
               collapsible = TRUE,
               fluidRow(
               column(width = 5, infoBox(title = 'Total Assets in Fleet', width = 12, value = textOutput("totalFleet", inline = TRUE), color = 'teal', fill = TRUE, icon = icon("car")),
                          infoBox(title = 'Fleet Replacement Count', width = 12, value = textOutput("totalGasSpent", inline = TRUE), color = 'green', fill = TRUE, icon = icon("cog"))),
               column(width = 7, h5("Fleet Breakdown"), htmlOutput("vehicleBreakdown"), br())
               ),
               fluidRow(
               column(width = 6, h5("MPG by Vehicle Type"), htmlOutput("mpgVehicleType")),
               column(width = 5, h5("Estimated CO2e / mile"), htmlOutput("agencyCompare"))
               
               
               )
               )
           ),
    column(width = 12,
           box(width = 12,
               title = 'Fleet List',
               status = 'info',
               collapsible = TRUE,
               dataTableOutput("fleetList")
               )
           )
)