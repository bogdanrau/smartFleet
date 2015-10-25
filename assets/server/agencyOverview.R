output$agencyAverageCo2e <- renderText({
    input$agency
    data <- dbGetQuery(smartFleet, paste0("SELECT AVG(Co2e) AS Co2e FROM smartFleet WHERE Agency LIKE '", input$agency, "%'"))
    average <- data[1,1]
    average <- round(average, digits = 2)
    return(average)
})

output$agencyAvgCo2e10 <- renderText({
    input$agency
    data <- dbGetQuery(smartFleet, paste0("SELECT AVG(Co2e2014) AS Co2e2014 FROM smartFleet WHERE Agency LIKE '", input$agency, "%'"))
    average <- data[1,1]
    average <- (average/1000000)*10
    average <- round(average, digits = 2)
    return(average)
})

output$agencyAvgCo2e100 <- renderText({
    input$agency
    data <- dbGetQuery(smartFleet, paste0("SELECT AVG(Co2e) AS Co2e FROM smartFleet WHERE Agency LIKE '", input$agency, "%'"))
    average <- data[1,1]
    average <- (average*100000)/1000000
    average <- round(average, digits = 2)
    return(average)
})

output$agencyTotalCo2e100 <- renderText({
    input$agency
    data <- dbGetQuery(smartFleet, paste0("SELECT SUM(Co2e2014) AS Co2e2014 FROM smartFleet WHERE Agency LIKE '", input$agency, "%'"))
    total <- data[1,1]
    total <- total/1000000
    total <- round(total, digits = 2)
    total <- format(total, big.mark = ",")
    return(total)
})

output$vehicleBreakdown <- renderGvis({
    input$agency
    data <- dbGetQuery(smartFleet, paste0("SELECT Vehicle_Type_Desc AS 'Vehicle Type', count(Vehicle_Type_Desc) AS Count FROM smartFleet WHERE Agency LIKE '", input$agency, "%' GROUP BY Vehicle_Type_Desc ORDER BY Count DESC"))

    theChart <- gvisPieChart(data = data, labelvar = "Type", numvar = "Count", 
                             options = list(
                                 width = '100%',
                                 chartArea = "{left:0, top:0, width:'100%', height:'95%'}",
                                 pieHole = 0.5,
                                 legend = "{position: 'right', textStile: {fontSize: 14}}",
                                 pieSliceText = 'none',
                                 chartid = "vehicleBreakdown"
                             ))
})

output$agencyCompare <- renderGvis({
    input$agency
    department <- dbGetQuery(smartFleet, paste0("SELECT AVG(Co2e) AS Co2E FROM smartFleet WHERE Agency LIKE '", input$agency, "%'"))
    state <- dbGetQuery(smartFleet, paste0("SELECT AVG(Co2e) AS Co2e FROM smartFleet"))
    
    data <- data.frame(Measurement = "CO2e", State = state[1,1], Department = department[1,1])
    theChart <- gvisColumnChart(data = data,
                                xvar = "Measurement",
                                yvar = c("State", "Department"),
                                options = list(
                                    height = 160,
                                    width = '100%',
                                    legend = "{position: 'bottom'}",
                                    chartArea = "{right:0,top:0,width:'92%',height:'90%'}",
                                    vAxis = "{title: 'Estimated CO2e / mile', textPosition: 'in', gridlines: {color: '#E3E3E3'}, minValue: 0}",
                                    hAxis = "{textPosition: 'none', gridlines: {color: '#E3E3E3'}}",
                                    series = "{0: {color:'#3c8dbc'}, 1:{color:'#FF8000'}, 2: {color:'#B40431'} }",
                                    chartid = "agencyCompare"
                                )
    )
})

output$mpgVehicleType <- renderGvis({
    input$agency
    data <- dbGetQuery(smartFleet, paste0("SELECT AVG(MPG) AS MPG, Vehicle_Type_Desc AS 'Vehicle_Type' FROM smartFleet WHERE Agency LIKE '", input$agency, "%' GROUP BY Vehicle_Type_Desc ORDER BY MPG DESC"))
    
    theChart <- gvisColumnChart(data = data,
                                xvar = "Vehicle_Type",
                                yvar = "MPG",
                                options = list(
                                    height = 160,
                                    width = '100%',
                                    legend = "{position: 'none'}",
                                    title = 'Comparison of Estimated CO2e / mile',
                                    chartArea = "{right:0,top:0,width:'92%',height:'90%'}",
                                    chartid = "mpgVehicleType"
                                ))
    
})

output$totalGasSpent <- renderText({
    input$agency
    data <- dbGetQuery(smartFleet, paste0("SELECT Count(*) AS Count FROM smartFleet WHERE Agency LIKE '", input$agency, "%' AND recommendation = 'Replace'"))
    data2 <- dbGetQuery(smartFleet, paste0("SELECT Count(*) FROM smartFleet WHERE Agency LIKE '", input$agency, "'"))
    total <- data[1,1]
    agencyTotal <- data2[1,1]
    theTotal <- paste0(total, " of ", agencyTotal)
    
    return(theTotal)
})

output$totalFleet <- renderText({
    input$agency
    data <- dbGetQuery(smartFleet, paste0("SELECT Count(*) AS Count FROM smartFleet WHERE Agency LIKE '", input$agency, "%'"))
    total <- data[1,1]
    return(total)
})

output$fleetList <- renderDataTable({
    input$agency
    data <- dbGetQuery(smartFleet, paste0("SELECT Make_Model, Model_Year, VIN, LifeMiles, Vehicle_Type_Desc, recommendation FROM smartFleet WHERE Agency LIKE '", input$agency, "%' ORDER BY LifeMiles DESC"))
    data$recommendation[data$recommendation == "Don't R"] <- "-"
    data$More <- paste0("<a target = '_blank' href='http://rstudio.bogdanrau.com:3838/smartFleet2/?VIN=", data$VIN, "'>More Info</a>")
    data <- rename(data, c("Make_Model" = "Make & Model", "Model_Year" = "Model Year", "LifeMiles" = "Lifetime Miles", "Vehicle_Type_Desc" = "Vehicle Type", "recommendation" = "Recommendation"))
    datatable(data = data, rownames = FALSE, filter = 'top', escape = FALSE, options = list(
        searching = TRUE,
        paging = TRUE,
        pageLength = 10,
        searchHighlight = TRUE
    ))
})