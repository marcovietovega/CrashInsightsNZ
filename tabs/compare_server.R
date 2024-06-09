# tabs/compare_server.R
compare_server <- function(input, output, session) {
  ns <- session$ns
  library(dplyr)
  library(DBI)
  library(RSQLite)
  
  con <- dbConnect(RSQLite::SQLite(), "./crash_data.sqlite")
  
  # Get unique values for region filters
  unique_regions <- reactive({
    query <- "SELECT DISTINCT region FROM crash_data"
    dbGetQuery(con, query)
  })
  
  observe({
    updateSelectInput(session, ns("region1"), choices = unique(unique_regions()$region))
    updateSelectInput(session, ns("region2"), choices = unique(unique_regions()$region))
  })
  
  filteredData1 <- reactive({
    req(input$region1)
    query <- paste("SELECT * FROM crash_data WHERE region = '", input$region1, "'", sep = "")
    dbGetQuery(con, query)
  })
  
  filteredData2 <- reactive({
    req(input$region2)
    query <- paste("SELECT * FROM crash_data WHERE region = '", input$region2, "'", sep = "")
    dbGetQuery(con, query)
  })
  
  output$plot1 <- renderPlotly({
    req(filteredData1(), filteredData2())
    
    data1 <- filteredData1() %>% count(crashSeverity)
    data1$region <- input$region1
    
    data2 <- filteredData2() %>% count(crashSeverity)
    data2$region <- input$region2
    
    combined_data <- rbind(data1, data2)
    
    plot_ly(combined_data, x = ~crashSeverity, y = ~n, color = ~region, type = 'bar') %>%
      layout(barmode = 'group', xaxis = list(title = "Crash Severity"), yaxis = list(title = "Number of Crashes"), showlegend = TRUE)
  })
  
  output$plot2 <- renderPlotly({
    req(filteredData1(), filteredData2())
    
    data1 <- filteredData1() %>% count(weatherA)
    data1$region <- input$region1
    
    data2 <- filteredData2() %>% count(weatherA)
    data2$region <- input$region2
    
    combined_data <- rbind(data1, data2)
    
    plot_ly(combined_data, labels = ~weatherA, values = ~n, type = 'pie', textinfo = 'label+percent', insidetextorientation = 'radial', pull = 0.05, color = ~region) %>%
      layout(showlegend = TRUE)
  })
  
  output$plot3 <- renderPlotly({
    req(filteredData1(), filteredData2())
    
    data1 <- filteredData1() %>% count(crashTime)
    data1$region <- input$region1
    
    data2 <- filteredData2() %>% count(crashTime)
    data2$region <- input$region2
    
    combined_data <- rbind(data1, data2)
    
    plot_ly(combined_data, x = ~crashTime, y = ~n, color = ~region, type = 'bar') %>%
      layout(barmode = 'group', xaxis = list(title = "Time of Day"), yaxis = list(title = "Number of Crashes"), showlegend = TRUE)
  })
  
  output$plot4 <- renderPlotly({
    req(filteredData1(), filteredData2())
    
    data1 <- filteredData1() %>% count(roadType)
    data1$region <- input$region1
    
    data2 <- filteredData2() %>% count(roadType)
    data2$region <- input$region2
    
    combined_data <- rbind(data1, data2)
    
    plot_ly(combined_data, x = ~roadType, y = ~n, color = ~region, type = 'bar') %>%
      layout(barmode = 'group', xaxis = list(title = "Road Type"), yaxis = list(title = "Number of Crashes"), showlegend = TRUE)
  })
  
  # Close the database connection when the session ends
  session$onSessionEnded(function() {
    dbDisconnect(con)
  })
}
