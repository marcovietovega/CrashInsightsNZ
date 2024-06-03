# server.R
library(shiny)
library(shinydashboard)
library(plotly)

source("tabs/home_server.R")
source("tabs/ml_server.R")
source("tabs/download_server.R")
source("tabs/compare_server.R")

server <- function(input, output, session) {
  callModule(home_server, "home")
  callModule(ml_server, "ml")
  callModule(download_server, "download")
  callModule(compare_server, "compare")
}
