output$vehicleTitle <- renderText({
    vin <- parseQueryString(session$clientData$url_search)
    vehicle_info <- dbGetQuery(smartFleet, paste0("SELECT Make_Model, License_Plate_Number FROM smartFleet WHERE VIN = '", vin, "'"))
    title <- paste0(vehicle_info[1,1], " [Plate #: ", vehicle_info[1,2], "]")
    return(title)
})

output$modelYear <- renderText({
    vin <- parseQueryString(session$clientData$url_search)
    modelYear <- dbGetQuery(smartFleet, paste0("SELECT Model_Year FROM smartFleet WHERE VIN = '", vin, "'"))
    return(modelYear[1,1])
})

output$vehicleType <- renderText({
    vin <- parseQueryString(session$clientData$url_search)
    vehicleType <- dbGetQuery(smartFleet, paste0("SELECT Vehicle_Type_Desc FROM smartFleet WHERE VIN = '", vin, "'"))
    return(vehicleType[1,1])
})

output$agency <- renderText({
    vin <- parseQueryString(session$clientData$url_search)
    agency <- dbGetQuery(smartFleet, paste0("SELECT Agency FROM smartFleet WHERE VIN = '", vin, "'"))
    return(agency[1,1])
})

output$equipmentNumber <- renderText({
    vin <- parseQueryString(session$clientData$url_search)
    equipmentNumber <- dbGetQuery(smartFleet, paste0("SELECT Equipment_Number FROM smartFleet WHERE VIN = '", vin, "'"))
    return(equipmentNumber[1,1])
})

output$vin <- renderText({
    vin <- parseQueryString(session$clientData$url_search)
    vin_number <- dbGetQuery(smartFleet, paste0("SELECT VIN FROM smartFleet WHERE VIN = '", vin, "'"))
    return(vin_number[1,1])
})

output$location <- renderText({
    vin <- parseQueryString(session$clientData$url_search)
    location <- dbGetQuery(smartFleet, paste0("SELECT Postal_Code FROM smartFleet WHERE VIN = '", vin, "'"))
    return(location[1,1])
})

output$MPG <- renderText({
    vin <- parseQueryString(session$clientData$url_search)
    MPG <- dbGetQuery(smartFleet, paste0("SELECT MPG FROM smartFleet WHERE VIN = '", vin, "'"))
    return(MPG[1,1])
})

output$lifeMiles <- renderText({
    vin <- parseQueryString(session$clientData$url_search)
    lifetimeMiles <- dbGetQuery(smartFleet, paste0("SELECT LifeMiles FROM smartFleet WHERE VIN = '", vin, "'"))
    return(format(lifetimeMiles[1,1], big.mark = ","))
})

output$totalMiles <- renderText({
    vin <- parseQueryString(session$clientData$url_search)
    totalMiles <- dbGetQuery(smartFleet, paste0("SELECT Total_Miles FROM smartFleet WHERE VIN = '", vin, "'"))
    return(format(totalMiles[1,1], big.mark = ","))
})

output$lifetimeCo2e <- renderText({
    vin <- parseQueryString(session$clientData$url_search)
    lifetimeCo2e <- dbGetQuery(smartFleet, paste0("SELECT LifeCo2e FROM smartFleet WHERE VIN = '", vin, "'"))
    lifetimeCo2e <- format(round(lifetimeCo2e[1,1]/1000000, digits = 2), big.mark = ",")
    lifetimeCo2e <- paste0(lifetimeCo2e, " metric tons")
    return(lifetimeCo2e)
})

output$thisYearCo2e <- renderText({
    vin <- parseQueryString(session$clientData$url_search)
    thisYearCo2e <- dbGetQuery(smartFleet, paste0("SELECT Co2e2014 FROM smartFleet WHERE VIN = '", vin, "'"))
    thisYearCo2e <- format(round(thisYearCo2e[1,1]/1000000, digits = 2), big.mark = ",")
    thisYearCo2e <- paste0(thisYearCo2e, " metric tons")
    return(thisYearCo2e)
})

output$sellPrice <- renderUI({
    api_key <- ''
    
    vin <- parseQueryString(session$clientData$url_search)
    zip <- dbGetQuery(smartFleet, paste0("SELECT Postal_Code FROM smartFleet WHERE VIN = '", vin, "'"))
    zip <- zip[1,1]
    mileage <- dbGetQuery(smartFleet, paste0("SELECT LifeMiles FROM smartFleet WHERE VIN = '", vin, "'"))
    mileage <- mileage[1,1]
    purchasePrice <- dbGetQuery(smartFleet, paste0("SELECT Purchase_Price FROM smartFleet WHERE VIN = '", vin, "'"))
    purchasePrice <- purchasePrice[1,1]
    purchasePrice <- format(purchasePrice, big.mark = ",")
    purchasePrice <- paste0("$", purchasePrice)
    recommendation <- dbGetQuery(smartFleet, paste0("SELECT recommendation FROM smartFleet WHERE VIN = '", vin, "'"))
    recommendation <- recommendation[1,1]
    if (recommendation == 'Replace') { recommend = 'Replace' }
    else if (recommendation != 'Replace') { recommend = "Don't Replace"}
    
    if (recommendation == 'Replace') { color = 'red' }
    else if (recommendation != 'Replace') { color = "green"}
    # Vehicle API Construction
    vehicle_url <- paste0('http://api.edmunds.com/api/vehicle/v2/vins/', vin, '?fmt=json&api_key=', api_key)
    vehicle_information <- fromJSON(vehicle_url)
    styleId <- vehicle_information$years[3][1,1][[1]][1,1]
    request_url <- paste0("http://api.edmunds.com/v1/api/tmv/tmvservice/calculateusedtmv?styleid=", styleId, "&condition=Average&zip=", zip, "&mileage=", mileage,"&fmt=json&api_key=", api_key)
    sale_price <- fromJSON(request_url)
    
    retail_price <- sale_price$tmv$nationalBasePrice$usedTmvRetail
    retail_price <- format(retail_price, big.mark = ',')
    tradeIn_price <- sale_price$tmv$nationalBasePrice$usedTradeIn
    tradeIn_price <- format(tradeIn_price, big.mark = ',')
    range <- paste0("$", tradeIn_price, " - $", retail_price)
    recommendation <- paste0("<div class = 'smartFleet-notification smartFleet-", color, "'><strong>", recommend, "</strong>  |  Purchase Price: ", purchasePrice, "  |  Estimated Sale Price: ", range, "</div>")
    HTML(recommendation)
})

output$photoURL <- renderUI({
    # EDMUNDS API IN R
    api_key <- ''
    
    vin <- parseQueryString(session$clientData$url_search)
    # Vehicle API Construction
    vehicle_url <- paste0('http://api.edmunds.com/api/vehicle/v2/vins/', vin, '?fmt=json&api_key=', api_key)
    vehicle_information <- fromJSON(vehicle_url)
    styleId <- vehicle_information$years[3][1,1][[1]][1,1]
    
    # Media API Integration
    request_url <- paste0('http://api.edmunds.com/v1/api/vehiclephoto/service/findphotosbystyleid?styleId=', styleId, '&api_key=', api_key, '&fmt=json')
    style_information <- fromJSON(request_url)
    photo_location <- style_information$photoSrcs[1][[1]][4]
    
    photo_url <- paste0('http://media.ed.edmunds-media.com', photo_location)
    image_location <- paste0("<img src = '", photo_url, "' class = 'img-responsive'>")

    HTML(image_location)
})

output$co2ecompare <- renderGvis({
    vin <- parseQueryString(session$clientData$url_search)

    state <- dbGetQuery(smartFleet, "SELECT AVG(Co2e) AS Co2e FROM smartFleet")
    theDepartment <- dbGetQuery(smartFleet, paste0("SELECT Agency FROM smartFleet WHERE VIN = '", vin, "'"))
    department <- dbGetQuery(smartFleet, paste0("SELECT AVG(Co2E) AS Co2e FROM smartFleet WHERE Agency = '", theDepartment[1], "'"))
    vehicle <- dbGetQuery(smartFleet, paste0("SELECT Co2e FROM smartFleet WHERE VIN = '", vin, "'"))
    
    data <- data.frame(Measurement = "CO2e", State = state[1,1], Department = department[1,1], Vehicle = vehicle[1,1])
    theChart <- gvisColumnChart(data = data,
                                xvar = "Measurement",
                                yvar = c("State", "Department", "Vehicle"),
                                options = list(
                                    height = 240,
                                    width = '100%',
                                    legend = "{position: 'bottom'}",
                                    title = 'Comparison of Estimated CO2e / mile',
                                    chartArea = "{right:0,top:0,width:'92%',height:'90%'}",
                                    vAxis = "{title: 'Estimated CO2e / mile', textPosition: 'in', gridlines: {color: '#E3E3E3'}, minValue: 0}",
                                    hAxis = "{textPosition: 'none', gridlines: {color: '#E3E3E3'}}",
                                    series = "{0: {color:'#3c8dbc'}, 1:{color:'#FF8000'}, 2: {color:'#B40431'} }",
                                    chartid = "co2ecompare"
                                )
                                )
})

output$co2eYRcompare <- renderGvis({
    vin <- parseQueryString(session$clientData$url_search)
    
    state <- dbGetQuery(smartFleet, "SELECT AVG(Co2e2014) AS Co2e FROM smartFleet")
    theDepartment <- dbGetQuery(smartFleet, paste0("SELECT Agency FROM smartFleet WHERE VIN = '", vin, "'"))
    department <- dbGetQuery(smartFleet, paste0("SELECT AVG(Co2E2014) AS Co2e FROM smartFleet WHERE Agency = '", theDepartment[1], "'"))
    vehicle <- dbGetQuery(smartFleet, paste0("SELECT Co2e2014 FROM smartFleet WHERE VIN = '", vin, "'"))
    
    data <- data.frame(Measurement = "CO2e", State = (state[1,1]/1000000)*10, Department = (department[1,1]/1000000)*10, Vehicle = (vehicle[1,1]/1000000)*10)
    
    theChart <- gvisBarChart(data = data, xvar="Measurement",
                               yvar=c("State", "Department", "Vehicle"),
                               options=list(
                                   height = 120,
                                   width = '100%',
                                   title = 'Average estimated 10-Year CO2e',
                                   legend = "{position: 'none'}",
                                   series = "{0: {color:'#3c8dbc'}, 1:{color:'#FF8000'}, 2: {color:'#B40431'} }",
                                   hAxis = "{minValue: 0}",
                                   vAxis = "{textPosition: 'none'}"
                                   )
                             )
})

output$co2e100kcompare <- renderGvis({
    vin <- parseQueryString(session$clientData$url_search)
    
    state <- dbGetQuery(smartFleet, "SELECT AVG(Co2e) AS Co2e FROM smartFleet")
    theDepartment <- dbGetQuery(smartFleet, paste0("SELECT Agency FROM smartFleet WHERE VIN = '", vin, "'"))
    department <- dbGetQuery(smartFleet, paste0("SELECT AVG(Co2E) AS Co2e FROM smartFleet WHERE Agency = '", theDepartment[1], "'"))
    vehicle <- dbGetQuery(smartFleet, paste0("SELECT Co2e FROM smartFleet WHERE VIN = '", vin, "'"))
    
    
    data <- data.frame(Measurement = "CO2e", State = (state[1,1]*100000)/1000000, Department = (department[1,1]*100000)/1000000, Vehicle = (vehicle[1,1]*100000)/1000000)
    
    theChart <- gvisBarChart(data = data, xvar="Measurement",
                             yvar=c("State", "Department", "Vehicle"),
                             options=list(
                                 height = 120,
                                 width = '100%',
                                 title = 'Average estimated CO2e per 100k miles',
                                 legend = "{position: 'none'}",
                                 series = "{0: {color:'#3c8dbc'}, 1:{color:'#FF8000'}, 2: {color:'#B40431'} }",
                                 hAxis = "{minValue: 0}",
                                 vAxis = "{textPosition: 'none'}"
                             )
    )
})

output$suggestedReplacements <- renderDataTable({
    vin <- parseQueryString(session$clientData$url_search)
    data <- dbGetQuery(smartFleet, paste0("SELECT * FROM smartRecommendations WHERE VIN = '", vin, "'"))
    data$Additional_Information <- paste0("<a href='", data$Link, "' target = '_blank'>More Information</a>")
    data$Link <- NULL
    data$VIN <- NULL
    data$Base_Price <- format(data$Base_Price, big.mark = ",")
    data$Base_Price <- paste0("$", data$Base_Price)
    data <- rename(data, c("Base_Price" = "Base Price", "Estimated_MPG" = "Estimated MPG", "Estimated_Co2e_Savings" = "Estimated CO2e Savings (%)", "Additional_Information" = "Additional Information"))
    datatable(data = data, rownames = FALSE, escape = FALSE, options = list(
        searching = FALSE,
        paging = FALSE,
        dom = 't',
        initComplete = JS(
            "function(settings, json) {",
            "$(this.api().table().header()).css({'background-color': '#3c8dbc', 'color': '#fff'});",
            "}")
    )) %>%
        formatStyle(
            'Estimated CO2e Savings (%)',
            background = styleColorBar(c(0, max(data$'Estimated CO2e Savings (%)') * 1.4), color = "lightblue"),
            backgroundSize = '100% 80%',
            backgroundRepeat = 'no-repeat',
            backgroundPosition = 'left'
        )
})




