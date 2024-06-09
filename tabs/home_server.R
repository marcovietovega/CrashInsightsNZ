home_server <- function(input, output, session) {
  ns <- session$ns
  library(dplyr)
  library(DBI)
  library(RSQLite)
  library(plotly)
  library(shinyWidgets)
  library(RColorBrewer)
  library(viridis)
  
  con <- dbConnect(SQLite(), "crash_data.sqlite")
  
  unique_regions <- reactive({
    dbGetQuery(con, "SELECT region FROM regions")
  })
  
  unique_years <- reactive({
    dbGetQuery(con, "SELECT crashYear FROM years")
  })
  
  unique_severity <- reactive({
    dbGetQuery(con, "SELECT crashSeverity FROM crashSeverity")
  })
  
  unique_weather <- reactive({
    dbGetQuery(con, "SELECT weather FROM weather")
  })
  
  unique_vehicle <- reactive({
    dbGetQuery(con,
               "SELECT vehicleType FROM vehicle_type order by vehicleType")
  })
  
  output$region_filter <- renderUI({
    req(unique_regions())
    pickerInput(
      ns("region"),
      "Select Region:",
      choices = unique_regions()$region,
      selected = unique_regions()$region,
      multiple = TRUE,
      options = pickerOptions(actionsBox = TRUE)
    )
  })
  
  output$year_filter <- renderUI({
    req(unique_years())
    years <- unique_years()$crashYear
    sliderInput(
      ns("year_filter"),
      "Select Year Range:",
      min = min(years),
      max = max(years),
      value = c(min(years), max(years)),
      step = 1,
      sep = "",
      ticks = FALSE
    )
  })
  
  output$severity_filter <- renderUI({
    req(unique_severity())
    pickerInput(
      ns("severity"),
      "Select Severity:",
      choices = unique_severity()$crashSeverity,
      selected = unique_severity()$crashSeverity,
      multiple = TRUE,
      options = pickerOptions(actionsBox = TRUE)
    )
  })
  
  output$weather_filter <- renderUI({
    req(unique_weather())
    pickerInput(
      ns("weather"),
      "Select Weather Conditions:",
      choices = unique_weather()$weather,
      selected = unique_weather()$weather,
      multiple = TRUE,
      options = pickerOptions(actionsBox = TRUE)
    )
  })
  
  output$vehicle_filter <- renderUI({
    req(unique_vehicle())
    pickerInput(
      ns("vehicle"),
      "Select Vehicle Type:",
      choices = unique_vehicle()$vehicleType,
      selected = unique_vehicle()$vehicleType,
      multiple = TRUE,
      options = pickerOptions(actionsBox = TRUE)
    )
  })
  
  filtered_data_totalcrashes <- reactive({
    req(input$region,
        input$year_filter,
        input$severity,
        input$weather,
        input$vehicle)
    
    query <- "SELECT sum(total_crashes) total_crashes FROM total_crashes WHERE crashYear BETWEEN ? AND ?"
    params <- list(input$year_filter[1], input$year_filter[2])
    
    if (length(input$region) < length(unique_regions()$region)) {
      regions_query <- paste0(" AND region IN (", paste(rep("?", length(input$region)), collapse = ", "), ")")
      query <- paste0(query, regions_query)
      params <- c(params, input$region)
    }
    
    if (length(input$severity) < length(unique_severity()$crashSeverity)) {
      severity_query <- paste0(" AND crashSeverity IN (", paste(rep("?", length(
        input$severity
      )), collapse = ", "), ")")
      query <- paste0(query, severity_query)
      params <- c(params, input$severity)
    }
    
    if (length(input$weather) < length(unique_weather()$weather)) {
      weather_query <- paste0(" AND weather IN (", paste(rep("?", length(
        input$weather
      )), collapse = ", "), ")")
      query <- paste0(query, weather_query)
      params <- c(params, input$weather)
    }
    
    if (length(input$vehicle) < length(unique_vehicle()$vehicleType)) {
      vehicle_query <- paste0(" AND vehicleType IN (", paste(rep("?", length(
        input$vehicle
      )), collapse = ", "), ")")
      query <- paste0(query, vehicle_query)
      params <- c(params, input$vehicle)
    }
    
    dbGetQuery(con, query, params = params)
  })
  
  filtered_data_totals_by_region <- reactive({
    req(input$region,
        input$year_filter,
        input$severity,
        input$weather,
        input$vehicle)
    
    query <- "SELECT region, sum(total_crashes) total_crashes FROM total_crashes WHERE crashYear BETWEEN ? AND ?"
    params <- list(input$year_filter[1], input$year_filter[2])
    
    if (length(input$region) < length(unique_regions()$region)) {
      regions_query <- paste0(" AND region IN (", paste(rep("?", length(input$region)), collapse = ", "), ")")
      query <- paste0(query, regions_query)
      params <- c(params, input$region)
    }
    
    if (length(input$severity) < length(unique_severity()$crashSeverity)) {
      severity_query <- paste0(" AND crashSeverity IN (", paste(rep("?", length(
        input$severity
      )), collapse = ", "), ")")
      query <- paste0(query, severity_query)
      params <- c(params, input$severity)
    }
    
    if (length(input$weather) < length(unique_weather()$weather)) {
      weather_query <- paste0(" AND weather IN (", paste(rep("?", length(
        input$weather
      )), collapse = ", "), ")")
      query <- paste0(query, weather_query)
      params <- c(params, input$weather)
    }
    
    if (length(input$vehicle) < length(unique_vehicle()$vehicleType)) {
      vehicle_query <- paste0(" AND vehicleType IN (", paste(rep("?", length(
        input$vehicle
      )), collapse = ", "), ")")
      query <- paste0(query, vehicle_query)
      params <- c(params, input$vehicle)
    }
    
    query <- paste0(query, " GROUP BY region")
    dbGetQuery(con, query, params = params)
  })
  
  filtered_data_totals_by_year <- reactive({
    req(input$region,
        input$year_filter,
        input$severity,
        input$weather,
        input$vehicle)
    
    query <- "SELECT crashYear, SUM(total_crashes) as total_crashes FROM total_crashes WHERE crashYear BETWEEN ? AND ?"
    params <- list(input$year_filter[1], input$year_filter[2])
    
    if (length(input$region) < length(unique_regions()$region)) {
      regions_query <- paste0(" AND region IN (", paste(rep("?", length(input$region)), collapse = ", "), ")")
      query <- paste0(query, regions_query)
      params <- c(params, input$region)
    }
    
    if (length(input$severity) < length(unique_severity()$crashSeverity)) {
      severity_query <- paste0(" AND crashSeverity IN (", paste(rep("?", length(
        input$severity
      )), collapse = ", "), ")")
      query <- paste0(query, severity_query)
      params <- c(params, input$severity)
    }
    
    if (length(input$weather) < length(unique_weather()$weather)) {
      weather_query <- paste0(" AND weather IN (", paste(rep("?", length(
        input$weather
      )), collapse = ", "), ")")
      query <- paste0(query, weather_query)
      params <- c(params, input$weather)
    }
    
    if (length(input$vehicle) < length(unique_vehicle()$vehicleType)) {
      vehicle_query <- paste0(" AND vehicleType IN (", paste(rep("?", length(
        input$vehicle
      )), collapse = ", "), ")")
      query <- paste0(query, vehicle_query)
      params <- c(params, input$vehicle)
    }
    
    query <- paste0(query, " GROUP BY crashYear ORDER BY crashYear")
    
    dbGetQuery(con, query, params = params)
  })
  
  filtered_data_vehicle_severity <- reactive({
    req(input$region,
        input$year_filter,
        input$severity,
        input$weather,
        input$vehicle)
    
    query <- "SELECT crashSeverity, vehicleType, SUM(total_crashes) total_crashes FROM vehicle_totals WHERE crashYear BETWEEN ? AND ?"
    params <- list(input$year_filter[1], input$year_filter[2])
    
    if (length(input$region) < length(unique_regions()$region)) {
      regions_query <- paste0(" AND region IN (", paste(rep("?", length(input$region)), collapse = ", "), ")")
      query <- paste0(query, regions_query)
      params <- c(params, input$region)
    }
    
    if (length(input$severity) < length(unique_severity()$crashSeverity)) {
      severity_query <- paste0(" AND crashSeverity IN (", paste(rep("?", length(
        input$severity
      )), collapse = ", "), ")")
      query <- paste0(query, severity_query)
      params <- c(params, input$severity)
    }
    
    if (length(input$weather) < length(unique_weather()$weather)) {
      weather_query <- paste0(" AND weather IN (", paste(rep("?", length(
        input$weather
      )), collapse = ", "), ")")
      query <- paste0(query, weather_query)
      params <- c(params, input$weather)
    }
    
    if (length(input$vehicle) < length(unique_vehicle()$vehicleType)) {
      vehicle_query <- paste0(" AND vehicleType IN (", paste(rep("?", length(
        input$vehicle
      )), collapse = ", "), ")")
      query <- paste0(query, vehicle_query)
      params <- c(params, input$vehicle)
    }
    
    query <- paste0(query, " GROUP BY crashSeverity, vehicleType")
    
    dbGetQuery(con, query, params = params)
  })
  
  filtered_data_totals_by_weather <- reactive({
    req(input$region,
        input$year_filter,
        input$severity,
        input$weather,
        input$vehicle)
    
    query <- "SELECT weather, SUM(total_crashes) as total_crashes FROM total_crashes WHERE crashYear BETWEEN ? AND ?"
    params <- list(input$year_filter[1], input$year_filter[2])
    
    if (length(input$region) < length(unique_regions()$region)) {
      regions_query <- paste0(" AND region IN (", paste(rep("?", length(input$region)), collapse = ", "), ")")
      query <- paste0(query, regions_query)
      params <- c(params, input$region)
    }
    
    if (length(input$severity) < length(unique_severity()$crashSeverity)) {
      severity_query <- paste0(" AND crashSeverity IN (", paste(rep("?", length(
        input$severity
      )), collapse = ", "), ")")
      query <- paste0(query, severity_query)
      params <- c(params, input$severity)
    }
    
    if (length(input$weather) < length(unique_weather()$weather)) {
      weather_query <- paste0(" AND weather IN (", paste(rep("?", length(
        input$weather
      )), collapse = ", "), ")")
      query <- paste0(query, weather_query)
      params <- c(params, input$weather)
    }
    
    if (length(input$vehicle) < length(unique_vehicle()$vehicleType)) {
      vehicle_query <- paste0(" AND vehicleType IN (", paste(rep("?", length(
        input$vehicle
      )), collapse = ", "), ")")
      query <- paste0(query, vehicle_query)
      params <- c(params, input$vehicle)
    }
    
    query <- paste0(query, " GROUP BY weather")
    
    dbGetQuery(con, query, params = params)
  })
  
  filtered_data_light_weather  <- reactive({
    req(input$region,
        input$year_filter,
        input$severity,
        input$weather,
        input$vehicle)
    
    query <- "SELECT light, weather, SUM(total_crashes) total_crashes FROM total_crashes WHERE crashYear BETWEEN ? AND ?"
    params <- list(input$year_filter[1], input$year_filter[2])
    
    if (length(input$region) < length(unique_regions()$region)) {
      regions_query <- paste0(" AND region IN (", paste(rep("?", length(input$region)), collapse = ", "), ")")
      query <- paste0(query, regions_query)
      params <- c(params, input$region)
    }
    
    if (length(input$severity) < length(unique_severity()$crashSeverity)) {
      severity_query <- paste0(" AND crashSeverity IN (", paste(rep("?", length(
        input$severity
      )), collapse = ", "), ")")
      query <- paste0(query, severity_query)
      params <- c(params, input$severity)
    }
    
    if (length(input$weather) < length(unique_weather()$weather)) {
      weather_query <- paste0(" AND weather IN (", paste(rep("?", length(
        input$weather
      )), collapse = ", "), ")")
      query <- paste0(query, weather_query)
      params <- c(params, input$weather)
    }
    
    if (length(input$vehicle) < length(unique_vehicle()$vehicleType)) {
      vehicle_query <- paste0(" AND vehicleType IN (", paste(rep("?", length(
        input$vehicle
      )), collapse = ", "), ")")
      query <- paste0(query, vehicle_query)
      params <- c(params, input$vehicle)
    }
    
    query <- paste0(query, " GROUP BY light, weather")
    
    dbGetQuery(con, query, params = params)
  })
  
  filtered_data_speedlimit <- reactive({
    req(input$region,
        input$year_filter,
        input$severity,
        input$weather,
        input$vehicle)
    
    query <- "SELECT SpeedLimit, SUM(total_crashes) total_crashes FROM total_crashes WHERE crashYear BETWEEN ? AND ?"
    params <- list(input$year_filter[1], input$year_filter[2])
    
    if (length(input$region) < length(unique_regions()$region)) {
      regions_query <- paste0(" AND region IN (", paste(rep("?", length(input$region)), collapse = ", "), ")")
      query <- paste0(query, regions_query)
      params <- c(params, input$region)
    }
    
    if (length(input$severity) < length(unique_severity()$crashSeverity)) {
      severity_query <- paste0(" AND crashSeverity IN (", paste(rep("?", length(
        input$severity
      )), collapse = ", "), ")")
      query <- paste0(query, severity_query)
      params <- c(params, input$severity)
    }
    
    if (length(input$weather) < length(unique_weather()$weather)) {
      weather_query <- paste0(" AND weather IN (", paste(rep("?", length(
        input$weather
      )), collapse = ", "), ")")
      query <- paste0(query, weather_query)
      params <- c(params, input$weather)
    }
    
    if (length(input$vehicle) < length(unique_vehicle()$vehicleType)) {
      vehicle_query <- paste0(" AND vehicleType IN (", paste(rep("?", length(
        input$vehicle
      )), collapse = ", "), ")")
      query <- paste0(query, vehicle_query)
      params <- c(params, input$vehicle)
    }
    
    query <- paste0(query, " GROUP BY speedLimit")
    
    dbGetQuery(con, query, params = params)
  })
  
  output$total_crashes <- renderValueBox({
    req(filtered_data_totalcrashes())
    total_crashes_data <- filtered_data_totalcrashes()
    total_crashes <- ifelse(is.na(total_crashes_data$total_crashes),
                            0,
                            total_crashes_data$total_crashes)
    valueBox(
      value = total_crashes,
      subtitle = "Total Crashes",
      icon = icon("car-crash"),
      color = "purple"
    )
  })
  
  output$top_region_1 <- renderValueBox({
    req(filtered_data_totals_by_region())
    
    data <- filtered_data_totals_by_region() %>%
      arrange(desc(total_crashes)) %>%
      slice_head(n = 1)
    
    valueBox(
      value = data$total_crashes,
      subtitle = paste("Region #1: ", data$region),
      icon = icon("map-marker-alt"),
      color = "orange"
    )
  })
  
  output$top_region_2 <- renderValueBox({
    req(filtered_data_totals_by_region())
    
    data <- filtered_data_totals_by_region() %>%
      arrange(desc(total_crashes)) %>%
      slice_head(n = 2) %>%
      slice_tail(n = 1)
    
    valueBox(
      value = data$total_crashes,
      subtitle = paste("Region #2: ", data$region),
      icon = icon("map-marker-alt"),
      color = "green"
    )
  })
  
  output$top_region_3 <- renderValueBox({
    req(filtered_data_totals_by_region())
    
    data <- filtered_data_totals_by_region() %>%
      arrange(desc(total_crashes)) %>%
      slice_head(n = 3) %>%
      slice_tail(n = 1)
    
    valueBox(
      value = data$total_crashes,
      subtitle = paste("Region #3: ", data$region),
      icon = icon("map-marker-alt"),
      color = "blue"
    )
  })
  
  output$line_trend_years <- renderPlotly({
    req(filtered_data_totals_by_year())
    plot_ly(
      filtered_data_totals_by_year(),
      x = ~ crashYear,
      y = ~ total_crashes,
      type = 'scatter',
      mode = 'lines',
      fill = 'tozeroy'
    ) %>%
      layout(
        xaxis = list(title = "Year"),
        yaxis = list(title = "Total Crashes", range = c(
          min(filtered_data_totals_by_year()$total_crashes) - 1000,
          max(filtered_data_totals_by_year()$total_crashes) + 1000
        )),
        margin = list(b = 100)
      )
  })
  
  output$bar_crash_region <- renderPlotly({
    req(filtered_data_totals_by_region())
    colors <- rev(brewer.pal(n = 10, name = "Blues"))
    plot_ly(
      filtered_data_totals_by_region(),
      x = ~ region,
      y = ~ total_crashes,
      color = ~ region,
      colors = colors,
      type = "bar"
    ) %>%
      layout(
        xaxis = list(title = "Regions", tickangle = -45),
        yaxis = list(title = "Number of Crashes"),
        margin = list(b = 1)
      )
  })
  
  output$pie_weather <- renderPlotly({
    req(filtered_data_totals_by_weather())
    colors <- rev(brewer.pal(n = 9, name = "Blues"))
    
    plot_ly(
      filtered_data_totals_by_weather(),
      labels = ~ weather,
      values = ~ total_crashes,
      type = 'pie',
      textinfo = 'percent',
      insidetextorientation = 'radial',
      marker = list(colors = colors)
    ) %>%
      layout(showlegend = TRUE)
  })
  
  output$stacked_vehicle_severity <- renderPlotly({
    req(filtered_data_vehicle_severity())
    colors <- (brewer.pal(n = 10, name = "Blues"))
    
    plot_ly(
      filtered_data_vehicle_severity(),
      x = ~ vehicleType,
      y = ~ total_crashes,
      color = ~ crashSeverity,
      colors = colors,
      type = 'bar'
    ) %>%
      layout(
        barmode = 'stack',
        xaxis = list(title = "Vehicle Types"),
        yaxis = list(title = "Number of Crashes"),
        margin = list(b = 100)
      )
  })
  
  output$stacked_light_weather <- renderPlotly({
    req(filtered_data_light_weather())
    colors <- rev(brewer.pal(n = 9, name = "Blues"))
    
    plot_ly(
      filtered_data_light_weather(),
      x = ~ light,
      y = ~ total_crashes,
      color = ~ weather,
      colors = colors,
      type = "bar"
    ) %>%
      layout(
        xaxis = list(title = "Light Conditions"),
        yaxis = list(title = "Total Crashes"),
        margin = list(b = 100)
      )
  })
  
  output$bubble_speed <- renderPlotly({
    req(filtered_data_speedlimit())
    colors <- (brewer.pal(n = 9, name = "Blues"))
    
    plot_ly(
      data = filtered_data_speedlimit(),
      x = ~ speedLimit,
      y = ~ total_crashes,
      size = ~ total_crashes,
      type = 'scatter',
      mode = 'markers',
      color = ~ speedLimit,
      colors = colors,
      marker = list(
        sizemode = 'diameter',
        opacity = 0.8
      ),
      showlegend = FALSE
    ) %>%
      layout(
        xaxis = list(title = "Speed Limit"),
        yaxis = list(title = "Total Crashes"),
        margin = list(b = 100)
      )
  })
  
  session$onSessionEnded(function() {
    dbDisconnect(con)
  })
}
