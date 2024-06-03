# tabs/home_server.R
home_server <- function(input, output, session) {
  ns <- session$ns
  library(dplyr)
  library(DBI)
  library(RSQLite)
  
  con <- dbConnect(RSQLite::SQLite(), "./crash_data.sqlite")
  
  # Get unique values for filters
  unique_values <- reactive({
    query <- "SELECT DISTINCT region, crashSeverity, weatherA FROM home_crash_data"
    dbGetQuery(con, query)
  })
  
  output$region_filter <- renderUI({
    req(unique_values())
    selectInput(ns("region"), "Select Region:", choices = c("All", unique(unique_values()$region)))
  })
  
  output$severity_filter <- renderUI({
    req(unique_values())
    selectInput(ns("severity"), "Select Crash Severity:", choices = c("All", unique(unique_values()$crashSeverity)))
  })
  
  output$weather_filter <- renderUI({
    req(unique_values())
    selectInput(ns("weather"), "Select Weather Conditions:", choices = c("All", unique(unique_values()$weatherA)))
  })
  
  filteredData <- reactive({
    query <- "SELECT * FROM home_crash_data WHERE 1=1"
    
    if (input$region != "All") {
      query <- paste(query, sprintf("AND region = '%s'", input$region))
    }
    if (input$severity != "All") {
      query <- paste(query, sprintf("AND crashSeverity = '%s'", input$severity))
    }
    if (input$weather != "All") {
      query <- paste(query, sprintf("AND weatherA = '%s'", input$weather))
    }
    
    dbGetQuery(con, query)
  })
  
  output$total_crashes <- renderValueBox({
    total_crashes <- nrow(filteredData())
    valueBox(total_crashes, "Total Crashes", icon = icon("car-crash"), color = "purple")
  })
  
  top_regions <- reactive({
    req(filteredData())
    filteredData() %>%
      count(region) %>%
      arrange(desc(n)) %>%
      slice(1:3)
  })
  
  output$top_region_1 <- renderValueBox({
    req(top_regions())
    valueBox(top_regions()$n[1], paste("Crashes in", top_regions()$region[1]), icon = icon("map-marker-alt"), color = "orange")
  })
  
  output$top_region_2 <- renderValueBox({
    req(top_regions())
    valueBox(top_regions()$n[2], paste("Crashes in", top_regions()$region[2]), icon = icon("map-marker-alt"), color = "green")
  })
  
  output$top_region_3 <- renderValueBox({
    req(top_regions())
    valueBox(top_regions()$n[3], paste("Crashes in", top_regions()$region[3]), icon = icon("map-marker-alt"), color = "blue")
  })
  
  output$plot1 <- renderPlotly({
    req(filteredData())
    severity_counts <- filteredData() %>%
      count(crashSeverity)
    plot_ly(severity_counts, labels = ~crashSeverity, values = ~n, type = 'pie', 
            marker = list(colors = c('#5A67D8', '#ECC94B', '#2D3748', '#4A5568', '#2B6CB0'))) %>%
      layout(showlegend = TRUE)
  })
  
  output$plot2 <- renderPlotly({
    req(filteredData())
    severity_counts <- filteredData() %>%
      count(crashSeverity)
    plot_ly(severity_counts, x = ~crashSeverity, y = ~n, type = 'bar', marker = list(color = '#ECC94B')) %>%
      layout(xaxis = list(title = "Crash Severity"), yaxis = list(title = "Number of Crashes"), showlegend = FALSE)
  })
  
  output$plot3 <- renderPlotly({
    req(filteredData())
    region_counts <- filteredData() %>%
      count(region)
    plot_ly(region_counts, x = ~region, y = ~n, type = 'bar', marker = list(color = '#5A67D8')) %>%
      layout(xaxis = list(title = "Region"), yaxis = list(title = "Number of Crashes"), showlegend = FALSE)
  })
  
  output$plot4 <- renderPlotly({
    req(filteredData())
    weather_counts <- filteredData() %>%
      count(weatherA)
    plot_ly(weather_counts, labels = ~weatherA, values = ~n, type = 'pie', 
            marker = list(colors = c('#5A67D8', '#ECC94B', '#2D3748', '#4A5568', '#2B6CB0'))) %>%
      layout(showlegend = TRUE)
  })
  
  # Close the database connection when the session ends
  session$onSessionEnded(function() {
    dbDisconnect(con)
  })
}
