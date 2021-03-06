#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readr)
library(httr)
library(jsonlite)
library(dplyr)
library(shinyWidgets)
library(shinybusy)

source('./src/ui.R')
source('./src/server.R')

options(shiny.sanitize.errors = FALSE)

# run ---------------------------------------------------------------------

shinyApp(ui = ui(), server = server)
