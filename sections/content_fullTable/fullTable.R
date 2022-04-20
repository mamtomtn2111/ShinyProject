getFullTableData <- function(groupBy) {
  padding_left <- max(str_length(data_evolution$value_new), na.rm = TRUE)
  data         <- data_evolution %>%
    filter(date == current_date) %>%
    pivot_wider(names_from = var, values_from = c(value, value_new)) %>%
    select(-date, -Lat, -Long) %>%
    add_row(
      "Province/State"      = "\u0054\u0068\u1ebf\u0020\u0067\u0069\u1edb\u0069",
      "Country/Region"      = "\u0054\u0068\u1ebf\u0020\u0067\u0069\u1edb\u0069",
      "population"          = 7800000000,
      "value_confirmed"     = sum(.$value_confirmed, na.rm = T),
      "value_new_confirmed" = sum(.$value_new_confirmed, na.rm = T),
      "value_recovered"     = sum(.$value_recovered, na.rm = T),
      "value_new_recovered" = sum(.$value_new_recovered, na.rm = T),
      "value_deceased"      = sum(.$value_deceased, na.rm = T),
      "value_new_deceased"  = sum(.$value_new_deceased, na.rm = T),
      "value_active"        = sum(.$value_active, na.rm = T),
      "value_new_active"    = sum(.$value_new_active, na.rm = T)
    ) %>%
    group_by(!!sym(groupBy), population) %>%
    summarise(
      confirmed_total     = sum(value_confirmed, na.rm = T),
      confirmed_new       = sum(value_new_confirmed, na.rm = T),
      confirmed_totalNorm = round(sum(value_confirmed, na.rm = T) / max(population, na.rm = T) * 100000, 2),
      recovered_total     = sum(value_recovered, na.rm = T),
      recovered_new       = sum(value_new_recovered, na.rm = T),
      deceased_total      = sum(value_deceased, na.rm = T),
      deceased_new        = sum(value_new_deceased, na.rm = T),
      active_total        = sum(value_active, na.rm = T),
      active_new          = sum(value_new_active, na.rm = T),
      active_totalNorm    = round(sum(value_active, na.rm = T) / max(population, na.rm = T) * 100000, 2)
    ) %>%
    mutate(
      "confirmed_newPer" = confirmed_new / (confirmed_total - confirmed_new) * 100,
      "recovered_newPer" = recovered_new / (recovered_total - recovered_new) * 100,
      "deceased_newPer"  = deceased_new / (deceased_total - deceased_new) * 100,
      "active_newPer"    = active_new / (active_total - active_new) * 100
    ) %>%
    mutate_at(vars(contains('_newPer')), list(~na_if(., Inf))) %>%
    mutate_at(vars(contains('_newPer')), list(~na_if(., 0))) %>%
    mutate(
      confirmed_new = str_c(str_pad(confirmed_new, width = padding_left, side = "left", pad = "0"), "|",
        confirmed_new, if_else(!is.na(confirmed_newPer), sprintf(" (%+.2f %%)", confirmed_newPer), "")),
      recovered_new = str_c(str_pad(recovered_new, width = padding_left, side = "left", pad = "0"), "|",
        recovered_new, if_else(!is.na(recovered_newPer), sprintf(" (%+.2f %%)", recovered_newPer), "")),
      deceased_new  = str_c(str_pad(deceased_new, width = padding_left, side = "left", pad = "0"), "|",
        deceased_new, if_else(!is.na(deceased_newPer), sprintf(" (%+.2f %%)", deceased_newPer), "")),
      active_new    = str_c(str_pad(active_new, width = padding_left, side = "left", pad = "0"), "|",
        active_new, if_else(!is.na(active_newPer), sprintf(" (%+.2f %%)", active_newPer), ""))
    ) %>%
    select(-population) %>%
    as.data.frame()
}

output$fullTable <- renderDataTable({
  data       <- getFullTableData("Country/Region")
  columNames <- c(
    "\u0051\u0075\u1ed1\u0063\u0020\u0067\u0069\u0061",
    "\u0054\u1ed5\u006e\u0067\u0020\u0073\u1ed1\u0020\u0063\u0061\u0020\u006e\u0068\u0069\u1ec5\u006d",
    "\u0053\u1ed1\u0020\u0063\u0061\u0020\u006e\u0068\u0069\u1ec5\u006d\u0020\u006d\u1edb\u0069",
    "\u0054\u1ed5\u006e\u0067\u0020\u0073\u1ed1\u0020\u0063\u0061\u0020\u006e\u0068\u0069\u1ec5\u006d <br>(\u006d\u1ed7\u0069 100k)",
    "\u0054\u1ed5\u006e\u0067\u0020\u0073\u1ed1\u0020\u0063\u0061\u0020\u0068\u1ed3\u0069\u0020\u0070\u0068\u1ee5\u0063\u0020\u0028\u0064\u1ef1\u0020\u0074\u00ed\u006e\u0068\u0029",
    "\u0053\u1ed1\u0020\u0063\u0061\u0020\u0068\u1ed3\u0069\u0020\u0070\u0068\u1ee5\u0063\u0020\u006d\u1edb\u0069",
    "\u0053\u1ed1\u0020\u0063\u0061\u0020\u0074\u1eed\u0020\u0076\u006f\u006e\u0067",
    "\u0053\u1ed1\u0020\u0063\u0061\u0020\u0074\u1eed\u0020\u0076\u006f\u006e\u0067\u0020\u006d\u1edb\u0069",
    "\u0053\u1ed1\u0020\u0063\u0061\u0020\u0063\u0068\u01b0\u0061\u0020\u006b\u0068\u1ecf\u0069",
    "\u0053\u1ed1\u0020\u0063\u0061\u0020\u0063\u0068\u01b0\u0061\u0020\u006b\u0068\u1ecf\u0069\u0020\u006d\u1edb\u0069",
    "\u0054\u1ed5\u006e\u0067\u0020\u0073\u1ed1\u0020\u0063\u0061\u0020\u0063\u0068\u01b0\u0061\u0020\u006b\u0068\u1ecf\u0069 <br>(\u006d\u1ed7\u0069 100k)")
  datatable(
    data,
    rownames  = FALSE,
    colnames  = columNames,
    escape    = FALSE,
    selection = "none",
    options   = list(
      pageLength     = -1,
      order          = list(8, "desc"),
      scrollX        = TRUE,
      scrollY        = "calc(100vh - 250px)",
      scrollCollapse = TRUE,
      dom            = "ft",
      server         = FALSE,
      columnDefs     = list(
        list(
          targets = c(2, 5, 7, 9),
          render  = JS(
            "function(data, type, row, meta) {
              if (data != null) {
                split = data.split('|')
                if (type == 'display') {
                  return split[1];
                } else {
                  return split[0];
                }
              }
            }"
          )
        ),
        list(className = 'dt-right', targets = 1:ncol(data) - 1),
        list(width = '100px', targets = 0),
        list(visible = FALSE, targets = 11:14)
      )
    )
  )
})