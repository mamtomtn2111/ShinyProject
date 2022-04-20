sumData <- function(date) {
  if (date >= min(data_evolution$date)) {
    data <- data_atDate(date) %>% summarise(
      confirmed = sum(confirmed, na.rm = T),
      recovered = sum(recovered, na.rm = T),
      deceased  = sum(deceased, na.rm = T),
      countries = n_distinct(`Country/Region`)
    )
    return(data)
  }
  return(NULL)
}

key_figures <- reactive({
  data           <- sumData(input$timeSlider)
  data_yesterday <- sumData(input$timeSlider - 1)

  data_new <- list(
    new_confirmed = (data$confirmed - data_yesterday$confirmed) / data_yesterday$confirmed * 100,
    new_recovered = (data$recovered - data_yesterday$recovered) / data_yesterday$recovered * 100,
    new_deceased  = (data$deceased - data_yesterday$deceased) / data_yesterday$deceased * 100,
    new_countries = data$countries - data_yesterday$countries
  )

  keyFigures <- list(
    "confirmed" = HTML(paste(format(data$confirmed, big.mark = " "), sprintf("<h4>(%+.1f %%)</h4>", data_new$new_confirmed))),
    "recovered" = HTML(paste(format(data$recovered, big.mark = " "), sprintf("<h4>(%+.1f %%)</h4>", data_new$new_recovered))),
    "deceased"  = HTML(paste(format(data$deceased, big.mark = " "), sprintf("<h4>(%+.1f %%)</h4>", data_new$new_deceased))),
    "countries" = HTML(paste(format(data$countries, big.mark = " "), "/ 195", sprintf("<h4>(%+d)</h4>", data_new$new_countries)))
  )
  return(keyFigures)
})

output$valueBox_confirmed <- renderValueBox({
  valueBox(
    key_figures()$confirmed,
    subtitle = "\u0043\u0061\u0020\u006e\u0068\u0069\u1ec5\u006d",
    icon     = icon("lungs-virus"),
    color    = "light-blue",
    width    = NULL
  )
})


output$valueBox_recovered <- renderValueBox({
  valueBox(
    key_figures()$recovered,
    subtitle = "\u0043\u0068\u01b0\u0061\u0020\u006b\u0068\u1ecf\u0069\u0020\u0062\u1ec7\u006e\u0068",
    icon     = icon("heartbeat"),
    color    = "green"
  )
})

output$valueBox_deceased <- renderValueBox({
  valueBox(
    key_figures()$deceased,
    subtitle = "\u0054\u1eed\u0020\u0076\u006f\u006e\u0067",
    icon     = icon("skull"),
    color    = "red"
  )
})

output$valueBox_countries <- renderValueBox({
  valueBox(
    key_figures()$countries,
    subtitle = "\u0051\u0075\u1ed1\u0063\u0020\u0067\u0069\u0061\u0020\u006e\u0068\u0069\u1ec5\u006d\u0020\u0062\u1ec7\u006e\u0068",
    icon     = icon("globe"),
    color    = "aqua"
  )
})

output$box_keyFigures <- renderUI(box(
  title = paste0("\u0053\u1ed1\u0020\u006c\u0069\u1ec7\u0075 (", strftime(input$timeSlider, format = "%d.%m.%Y"), ")"),
  fluidRow(
    column(
      valueBoxOutput("valueBox_confirmed", width = 3),
      valueBoxOutput("valueBox_recovered", width = 3),
      valueBoxOutput("valueBox_deceased", width = 3),
      valueBoxOutput("valueBox_countries", width = 3),
      width = 12,
      style = "margin-left: -20px"
    )
  ),
  div("\u0043\u1ead\u0070\u0020\u006e\u0068\u1ead\u0074\u0020\u006c\u1ea7\u006e\u0020\u0063\u0075\u1ed1\u0069\u003a ", strftime(changed_date, format = "%d.%m.%Y - %R %Z")),
  width = 12
))
