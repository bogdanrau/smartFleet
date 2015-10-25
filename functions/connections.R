## FUNCTIONS FOR SQL DATABASE CONNECTIONS
smartFleetConnect <- function() {
    if (!exists("smartFleet", where = .GlobalEnv)) {
        smartFleet <<- dbConnect(MySQL(), default.file= mysqlconf, dbname = "smartFleet")
    } else if (class(try(dbGetQuery(smartFleet, "SELECT 1"))) == "try-error") {
        dbDisconnect(smartFleet)
        smartFleet <<- dbConnect(MySQL(), default.file = mysqlconf, dbname = "smartFleet")
    }
    return(smartFleet)
}