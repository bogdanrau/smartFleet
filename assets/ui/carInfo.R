fluidRow(
    column(width = 12,
           fluidRow(
               column(width = 12,
                      h3(textOutput("vehicleTitle"))
                      )
               ),
           fluidRow(
               box(width = 12,
                    title = "BASIC VEHICLE INFORMATION",
                    collapsible = TRUE,
                    status = "primary",
                    footer = "Some information is provided by the Edmunds.com Vehicle API.",
                      fluidRow(
                          column(width = 4, htmlOutput("photoURL")),
                          column(width = 4, 
                                 box(
                                     title = NULL,
                                     width = 12,
                                     background = NULL,
                                     tags$b("Model Year: "), textOutput("modelYear", inline = TRUE), br(), br(),
                                     tags$b("Vehicle Type: "), textOutput("vehicleType", inline = TRUE), br(), br(),
                                     tags$b("Agency: "), textOutput("agency", inline = TRUE), br(), br(),
                                     tags$b("Equipment #: "), textOutput("equipmentNumber", inline = TRUE), br(), br(),
                                     tags$b("VIN: "), textOutput("vin", inline = TRUE), br(), br(),
                                     tags$b("Location: "), textOutput("location", inline = TRUE), br())
                                 ),
                          column(width = 4,
                                 box(
                                     title = NULL,
                                     width = 12,
                                     background = "light-blue",
                                     tags$b("Estimated MPG: "), textOutput("MPG", inline = TRUE), br(), br(),
                                     tags$b("Lifetime Miles: "), textOutput("lifeMiles", inline = TRUE), br(), br(),
                                     tags$b("Miles Last Year: "), textOutput("totalMiles", inline = TRUE), br(), br(),
                                     tags$b("Lifetime CO2e: "), textOutput("lifetimeCo2e", inline = TRUE), br(), br(),
                                     tags$b("CO2e Last Year: "), textOutput("thisYearCo2e", inline = TRUE)
                                 )
                                 )
                          ),
                   fluidRow(
                       column(width = 12, br(), htmlOutput("sellPrice"))
                   )
                      )
               ),
           fluidRow(
               box(width = 12,
                   title = "EMISSIONS INFORMATION",
                   collapsible = TRUE,
                   status = "success",
                   solidHeader = TRUE,
                   footer = 'Vehicle emissions are calculated using EPA-recommended guidelines.',
                   column(width = 5, htmlOutput("co2ecompare")),
                   column(width = 7, 
                          fluidRow(
                              column(width = 12, htmlOutput("co2eYRcompare"), br())
                          ),
                          fluidRow(
                              column(width = 12, htmlOutput("co2e100kcompare"))
                          )
                          )
                   )
               ),
           fluidRow(
               box(width = 12,
                   title = "SUGGESTED REPLACEMENTS",
                   collapsible = TRUE,
                   collapsed = TRUE,
                   status = "warning",
                   solidHeader = FALSE,
                   dataTableOutput("suggestedReplacements"))
           )
           )
)