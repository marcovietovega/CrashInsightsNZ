library(shiny)
library(dplyr)
library(DBI)
library(RSQLite)
library(RColorBrewer)

compare_server <- function(input, output, session) {
  ns <- session$ns
  
  con <- dbConnect(SQLite(), "crash_data.sqlite")
  
  regions <- reactive({
    dbGetQuery(con, "SELECT region FROM regions")
  })
  
  output$region1 <- renderUI({
    req(regions())
    selectInput(
      ns("region1"), 
      "Select Region 1:", 
      choices = c("Select a region" = "", regions()$region)
    )
  })
  
  output$region2 <- renderUI({
    req(regions())
    selectInput(
      ns("region2"), 
      "Select Region 2:", 
      choices = c("Select a region" = "", regions()$region)
    )
  })
  
  total_crashes_region <- function(region) {
    query <- paste0("SELECT SUM(total_crashes) as total_crashes FROM total_crashes WHERE region = ?")
    result <- dbGetQuery(con, query, params = list(region))
    result$total_crashes
  }
  
  region1_total_crashes <- reactive({
    req(input$region1)
    if (input$region1 != "") {
      total_crashes_region(input$region1)
    } else {
      NA
    }
  })
  
  region2_total_crashes <- reactive({
    req(input$region2)
    if (input$region2 != "") {
      total_crashes_region(input$region2)
    } else {
      NA
    }
  })
  
  output$region1_total_crashes <- renderValueBox({
    req(region1_total_crashes(), region2_total_crashes())
    total1 <- region1_total_crashes()
    total2 <- region2_total_crashes()
    
    color <- if (!is.na(total1) && total1 >= total2) "red" else "purple"
    
    valueBox(
      value = ifelse(is.na(total1), "Please select a region", total1),
      subtitle = ifelse(is.na(total1), "Total Crashes", paste("Total Crashes in", input$region1)),
      icon = icon("car-crash"),
      color = color
    )
  })
  
  output$region2_total_crashes <- renderValueBox({
    req(region1_total_crashes(), region2_total_crashes())
    total1 <- region1_total_crashes()
    total2 <- region2_total_crashes()
    
    color <- if (!is.na(total2) && total2 >= total1) "red" else "purple"
    
    valueBox(
      value = ifelse(is.na(total2), "Please select a region", total2),
      subtitle = ifelse(is.na(total2), "Total Crashes", paste("Total Crashes in", input$region2)),
      icon = icon("car-crash"),
      color = color
    )
  })
  
  yearly_crashes_region <- function(region) {
    query <- paste0("SELECT crashYear, SUM(total_crashes) as total_crashes FROM total_crashes WHERE region = ? GROUP BY crashYear ORDER BY crashYear")
    result <- dbGetQuery(con, query, params = list(region))
    result
  }
  
  output$line_trend_years_1 <- renderPlotly({
    req(input$region1, input$region2)
    data1 <- yearly_crashes_region(input$region1)
    data2 <- if (input$region2 != "") yearly_crashes_region(input$region2) else data.frame(crashYear = integer(), total_crashes = integer())
    
    max_crashes <- max(data1$total_crashes, data2$total_crashes, na.rm = TRUE)
    
    if (input$region1 != "") {
      data <- yearly_crashes_region(input$region1)
      plot_ly(data, 
              x = ~crashYear, 
              y = ~total_crashes, 
              type = 'scatter', 
              mode = 'lines',
              fill = 'tozeroy') %>%
        layout(xaxis = list(title = "Year"), 
               yaxis = list(title = "Total Crashes", range = c(0, max_crashes)))
    }
  })
  
  output$line_trend_years_2 <- renderPlotly({
    req(input$region1, input$region2)
    data1 <- if (input$region1 != "") yearly_crashes_region(input$region1) else data.frame(crashYear = integer(), total_crashes = integer())
    data2 <- yearly_crashes_region(input$region2)
    
    max_crashes <- max(data1$total_crashes, data2$total_crashes, na.rm = TRUE)
    
    if (input$region2 != "") {
      data <- yearly_crashes_region(input$region2)
      plot_ly(data, 
              x = ~crashYear, 
              y = ~total_crashes, 
              type = 'scatter', 
              mode = 'lines',
              fill = 'tozeroy') %>%
        layout(xaxis = list(title = "Year"), 
               yaxis = list(title = "Total Crashes", range = c(0, max_crashes)))
    }
  })
  
  total_fatal_region <- function(region) {
    query <- paste0("SELECT SUM(total_fatal_count) as total_fatal_count FROM fatal_count_by_region WHERE region = ?")
    result <- dbGetQuery(con, query, params = list(region))
    result$total_fatal_count
  }
  
  region1_fatal_count <- reactive({
    req(input$region1)
    if (input$region1 != "") {
      total_fatal_region(input$region1)
    } else {
      NA
    }
  })
  
  region2_fatal_count <- reactive({
    req(input$region2)
    if (input$region2 != "") {
      total_fatal_region(input$region2)
    } else {
      NA
    }
  })
  
  output$region1_total_fatal <- renderValueBox({
    req(region1_fatal_count(), region2_fatal_count())
    
    total1 <- region1_fatal_count()
    total2 <- region2_fatal_count()
    
    color <- if (!is.na(total1) && total1 >= total2) "red" else "purple"
    
    valueBox(
      value = ifelse(is.na(total1), "Please select a region", total1),
      subtitle = ifelse(is.na(total1), "Fatalities in Crashes", paste("Fatalities in Crashes in", input$region1)),
      icon = icon("exclamation-triangle"),
      color = color
    )
  })
  
  output$region2_total_fatal <- renderValueBox({
    req(region1_fatal_count(), region2_fatal_count())
    
    total1 <- region1_fatal_count()
    total2 <- region2_fatal_count()
    
    color <- if (!is.na(total2) && total2 >= total1) "red" else "purple"
    
    valueBox(
      value = ifelse(is.na(total2), "Please select a region", total2),
      subtitle = ifelse(is.na(total2), "Fatalities in Crashes", paste("Fatalities in Crashes in", input$region2)),
      icon = icon("exclamation-triangle"),
      color = color
    )
  })
  
  total_severity_region <- function(region) {
    query <- paste0("SELECT crashSeverity, SUM(total_crashes) as total_crashes FROM total_crashes WHERE region = ? GROUP BY crashSeverity ORDER BY crashYear")
    result <- dbGetQuery(con, query, params = list(region))
    result
  }
  
  output$donut_severity_1 <- renderPlotly({
    req(input$region1, input$region2)
    colors <- rev(brewer.pal(n = 9, name = "RdBu"))
    
    data1 <- total_severity_region(input$region1)
    data2 <- if (input$region2 != "") total_severity_region(input$region2) else data.frame(crashSeverity = character(), total_crashes = integer())
    
    if (input$region1 != "") {
      data <- total_severity_region(input$region1)
      plot_ly(data, 
              labels = ~crashSeverity, 
              values = ~total_crashes, 
              type = 'pie', 
              hole = 0.5, 
              textinfo = 'label+percent',
              insidetextorientation = 'radial',
              marker = list(colors = colors))
    }
  })
  
  output$donut_severity_2 <- renderPlotly({
    req(input$region1, input$region2)
    colors <- rev(brewer.pal(n = 9, name = "RdBu"))
    
    data1 <- if (input$region1 != "") total_severity_region(input$region1) else data.frame(crashSeverity = character(), total_crashes = integer())
    data2 <- total_severity_region(input$region2)
    
    if (input$region2 != "") {
      data <- total_severity_region(input$region2)
      plot_ly(data, 
              labels = ~crashSeverity, 
              values = ~total_crashes, 
              type = 'pie', 
              hole = 0.5, 
              textinfo = 'label+percent',
              insidetextorientation = 'radial',
              marker = list(colors = colors))
    }
  })
  
  avg_speed_region <- function(region) {
    query <- paste0("SELECT average_speed_limit FROM average_speed_limit_by_region WHERE region = ?")
    result <- dbGetQuery(con, query, params = list(region))
    result$average_speed_limit
  }
  
  region1_avg_speed <- reactive({
    req(input$region1)
    if (input$region1 != "") {
      avg_speed_region(input$region1)
    } else {
      NA
    }
  })
  
  region2_avg_speed <- reactive({
    req(input$region2)
    if (input$region2 != "") {
      avg_speed_region(input$region2)
    } else {
      NA
    }
  })
  
  output$region1_avg_speed <- renderValueBox({
    req(region1_avg_speed(), region2_avg_speed())
    total1 <- region1_avg_speed()
    total2 <- region2_avg_speed()
    
    color <- if (!is.na(total1) && total1 >= total2) "red" else "purple"
    
    valueBox(
      value = ifelse(is.na(total1), "Please select a region", paste(total1,"mph")),
      subtitle = ifelse(is.na(total1), "Average Speed Limit in Crashes in", paste("Average Speed Limit in Crashes in", input$region1)),
      icon = icon("tachometer-alt"),
      color = color
    )
  })
  
  output$region2_avg_speed <- renderValueBox({
    req(region1_avg_speed(), region2_avg_speed())
    total1 <- region1_avg_speed()
    total2 <- region2_avg_speed()
    
    color <- if (!is.na(total2) && total2 >= total1) "red" else "purple"
    
    valueBox(
      value = ifelse(is.na(total2), "Please select a region", paste(total2,"mph")),
      subtitle = ifelse(is.na(total2), "Average Speed Limit in Crashes in", paste("Average Speed Limit in Crashes in", input$region2)),
      icon = icon("tachometer-alt"),
      color = color
    )
  })
  
  crashes_weather_region <- function(region) {
    query <- paste0("SELECT weather, SUM(total_crashes) as total_crashes FROM total_crashes WHERE region = ? GROUP BY weather")
    result <- dbGetQuery(con, query, params = list(region))
    result
  }
  
  output$bar_weather_1 <- renderPlotly({
    colors <- rev(brewer.pal(n = 10, name = "Blues"))

    data1 <- crashes_weather_region(input$region1)
    data2 <- if (input$region2 != "") crashes_weather_region(input$region2) else data.frame(crashYear = integer(), total_crashes = integer())
    
    max_crashes <- max(data1$total_crashes, data2$total_crashes, na.rm = TRUE)
    
    if (input$region1 != "") {
      data <- crashes_weather_region(input$region1)
      plot_ly(data, 
              x = ~weather, 
              y = ~total_crashes, 
              type = 'bar',
              color = ~ weather,
              colors = colors) %>%
        layout(xaxis = list(title = "Weather Conditions"),
               yaxis = list(title = "Total Crashes", range = c(0, max_crashes)))
    }
  })
  
  output$bar_weather_2 <- renderPlotly({
    req(input$region2)
    colors <- rev(brewer.pal(n = 10, name = "Blues"))
    
    data1 <- if (input$region1 != "") crashes_weather_region(input$region1) else data.frame(crashYear = integer(), total_crashes = integer())
    data2 <- crashes_weather_region(input$region2)
    
    max_crashes <- max(data1$total_crashes, data2$total_crashes, na.rm = TRUE)
    
    if (input$region2 != "") {
      data <- crashes_weather_region(input$region2)
      plot_ly(data, 
              x = ~weather, 
              y = ~total_crashes, 
              type = 'bar',
              color = ~ weather,
              colors = colors) %>%
        layout(xaxis = list(title = "Weather Conditions"),
               yaxis = list(title = "Total Crashes", range = c(0, max_crashes)))
    }
  })
  
  holiday_crashes_region <- function(region) {
    query <- paste0("SELECT sum(total_crashes) total_crashes FROM total_crashes_holiday_region WHERE region = ?")
    result <- dbGetQuery(con, query, params = list(region))
    result$total_crashes
  }
  
  region1_holiday_crashes <- reactive({
    req(input$region1)
    if (input$region1 != "") {
      holiday_crashes_region(input$region1)
    } else {
      NA
    }
  })
  
  region2_holiday_crashes <- reactive({
    req(input$region2)
    if (input$region2 != "") {
      holiday_crashes_region(input$region2)
    } else {
      NA
    }
  })
  
  output$region1_holiday_region <- renderValueBox({
    req(region1_holiday_crashes(), region2_holiday_crashes())
    total1 <- region1_holiday_crashes()
    total2 <- region2_holiday_crashes()
    
    color <- if (!is.na(total1) && total1 >= total2) "red" else "purple"
    
    valueBox(
      value = ifelse(is.na(total1), "Please select a region", total1),
      subtitle = ifelse(is.na(total1), "Crashes during Holydays in", paste("Crashes during Holydays in", input$region1)),
      icon = icon("calendar-alt"),
      color = color
    )
  })
  
  output$region2_holiday_region <- renderValueBox({
    req(region1_holiday_crashes(), region2_holiday_crashes())
    total1 <- region1_holiday_crashes()
    total2 <- region2_holiday_crashes()
    
    color <- if (!is.na(total2) && total2 >= total1) "red" else "purple"
    
    valueBox(
      value = ifelse(is.na(total2), "Please select a region", total2),
      subtitle = ifelse(is.na(total2), "Crashes during Holydays in", paste("Crashes during Holydays in", input$region2)),
      icon = icon("calendar-alt"),
      color = color
    )
  })
  
  crashes_vehicle_region <- function(region) {
    query <- "SELECT vehicleType, SUM(total_crashes) as total_crashes FROM vehicle_totals WHERE region = ? GROUP BY vehicleType"
    result <- dbGetQuery(con, query, params = list(region))
    result
  }
  
  output$bar_vehicle_region1 <- renderPlotly({
    colors <- rev(brewer.pal(n = 10, name = "Blues"))
    req(input$region1)
    
    data1 <- crashes_vehicle_region(input$region1)
    data2 <- if (input$region2 != "") crashes_vehicle_region(input$region2) else data.frame(crashYear = integer(), total_crashes = integer())
    
    max_crashes <- max(data1$total_crashes, data2$total_crashes, na.rm = TRUE)
    
    if (input$region1 != "") {
      data <- crashes_vehicle_region(input$region1)
      plot_ly(data, 
              x = ~total_crashes, 
              y = ~vehicleType, 
              type = 'bar', 
              orientation = 'h',
              color = ~ vehicleType,
              colors = colors) %>%
        layout(xaxis = list(title = "Total Crashes", range = c(0, max_crashes)),
               yaxis = list(title = "Vehicle Type"))
    }
  })
  
  output$bar_vehicle_region2 <- renderPlotly({
    colors <- rev(brewer.pal(n = 10, name = "Blues"))
    req(input$region2)
    
    data1 <- if (input$region1 != "") crashes_vehicle_region(input$region1) else data.frame(crashYear = integer(), total_crashes = integer())
    data2 <- crashes_vehicle_region(input$region2)
    
    max_crashes <- max(data1$total_crashes, data2$total_crashes, na.rm = TRUE)
    
    if (input$region2 != "") {
      data <- crashes_vehicle_region(input$region2)
      plot_ly(data, 
              x = ~total_crashes, 
              y = ~vehicleType, 
              type = 'bar', 
              orientation = 'h',
              color = ~ vehicleType,
              colors = colors) %>%
        layout(xaxis = list(title = "Total Crashes", range = c(0, max_crashes)),
               yaxis = list(title = "Vehicle Type"))
    }
  })
  
  session$onSessionEnded(function() {
    dbDisconnect(con)
  })
}