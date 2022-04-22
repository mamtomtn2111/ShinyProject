output$selectize_casesByCountriesAfter100th <- renderUI({
  selectizeInput(
    "caseEvolution_countryAfter100th",
    label    = "\u0043\u0068\u1ecd\u006e\u0020\u0071\u0075\u1ed1\u0063\u0020\u0067\u0069\u0061",
    choices  = unique(data_evolution$`Country/Region`),
    selected = top5_countries,
    multiple = TRUE
  )
})

output$selectize_casesSince100th <- renderUI({
  selectizeInput(
    "caseEvolution_var100th",
    label    = "\u0043\u0068\u1ecd\u006e\u0020\u0074\u0068\u0061\u006d\u0020\u0073\u1ed1",
    choices  = list("Confirmed" = "confirmed", "Decreased" = "deceased"),
    multiple = FALSE
  )
})

output$case_evolution_after100 <- renderPlotly({
  req(!is.null(input$checkbox_per100kEvolutionCountry100th), input$caseEvolution_var100th)
  data <- data_evolution %>%
    arrange(date) %>%
    filter(if (input$caseEvolution_var100th == "confirmed") (value >= 100 & var == "confirmed") else (value >= 10 & var == "deceased")) %>%
    group_by(`Country/Region`, population, date) %>%
    filter(if (is.null(input$caseEvolution_countryAfter100th)) TRUE else `Country/Region` %in% input$caseEvolution_countryAfter100th) %>%
    summarise(value = sum(value, na.rm = T)) %>%
    mutate("daysSince" = row_number()) %>%
    ungroup()

  if (input$checkbox_per100kEvolutionCountry100th) {
    data$value <- data$value / data$population * 100000
  }

  p <- plot_ly(data = data, x = ~daysSince, y = ~value, color = ~`Country/Region`, type = 'scatter', mode = 'lines')

  if (input$caseEvolution_var100th == "confirmed") {
    p <- layout(p,
      yaxis = list(title = "\u0053\u1ed1\u0020\u0063\u0061\u0020\u006e\u0068\u0069\u1ec5\u006d\u000d"),
      xaxis = list(title = "\u0053\u1ed1\u0020\u006e\u0067\u00e0\u0079\u0020\u006b\u1ec3\u0020\u0074\u1eeb\u0020\u0063\u0061\u0020\u006e\u0068\u0069\u1ec5\u006d\u0020\u0074\u0068\u1ee9\u0020\u0031\u0030\u0030\u000d")
    )
  } else {
    p <- layout(p,
      yaxis = list(title = "\u0053\u1ed1\u0020\u0063\u0061\u0020\u0074\u1eed\u0020\u0076\u006f\u006e\u0067\u000d"),
      xaxis = list(title = "\u0053\u1ed1\u0020\u006e\u0067\u00e0\u0079\u0020\u006b\u1ec3\u0020\u0074\u1eeb\u0020\u006e\u0067\u00e0\u0079\u0020\u0063\u00f3\u0020\u0063\u0061\u0020\u0074\u1eed\u0020\u0076\u006f\u006e\u0067\u0020\u0074\u0068\u1ee9\u0020\u0031\u0030")
    )
  }
  if (input$checkbox_logCaseEvolution100th) {
    p <- layout(p, yaxis = list(type = "log"))
  }
  if (input$checkbox_per100kEvolutionCountry100th) {
    p <- layout(p, yaxis = list(title = "# Cases per 100k Inhabitants"))
  }

  return(p)
})
