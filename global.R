# LOAD REQUIRED PACKAGES
library(shiny)          # REQUIRED FOR SHINY APPLICATION FUNCTIONALITY
library(shinyBS)        # EXTENDS BOOTSTRAP FUNCTIONALITY TO SHINY APPS
library(shinydashboard) # REQUIRED FOR SHINY DASHBOARD APPEARANCE
library(sqldf)          # REQUIRED FOR RUNNING SQL STATEMENDS ON DATA FRAMES
library(RMySQL)         # REQUIRED FOR CONNECTING TO MYSQL DATABASES
library(googleVis)      # REQUIRED FOR INTERACTIVE CHART GENERATION
library(plyr)           # REQUIRED FOR DATA MANIPULATION
library(leaflet)        # LEAFLET FOR MAPS
library(DT)
library(jsonlite)

source("functions/connections.R")
mysqlconf <- "/home/bogdan/R-Programs/smartFleet.cnf"

load('assets/departments.Rda')

