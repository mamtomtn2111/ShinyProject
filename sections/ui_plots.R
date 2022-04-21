body_plots <- dashboardBody(
  fluidRow(
    fluidRow(
      fluidRow(
        box(
          title = "\u0053\u1ed1\u0020\u0063\u0061\u0020\u0074\u0068\u1ebf\u0020\u0067\u0069\u1edb\u0069\u0020\u0074\u1eeb\u0020\u006c\u00fa\u0063\u0020\u0062\u00f9\u006e\u0067\u0020\u0070\u0068\u00e1\u0074",
          plotlyOutput("case_evolution"),
          column(
            checkboxInput("checkbox_logCaseEvolution", label = "Logarithmic Y-Axis", value = FALSE),
            width = 3,
            style = "float: right; padding: 10px; margin-right: 50px"
          ),
          width = 6
        ),
        box(
          title = "\u0053\u1ed1\u0020\u0063\u0061\u0020\u006d\u1edb\u0069",
          plotlyOutput("case_evolution_new"),
          column(
            uiOutput("selectize_casesByCountries_new"),
            width = 3,
          ),
          column(
            HTML("Note: Active cases are calculated as <i>Confirmed - (Estimated Recoveries + Deceased)</i>. Therefore, <i>new</i> active cases can
          be negative for some days, if on this day there were more new estimated recoveries + deceased cases than there were new
          confirmed cases."),
            width = 7
          ),
          width = 6
        )
      ),
      fluidRow(
        box(
          title = "\u0053\u1ed1\u0020\u0063\u0061\u0020\u0074\u1eeb\u006e\u0067\u0020\u0071\u0075\u1ed1\u0063\u0020\u0067\u0069\u0061",
          plotlyOutput("case_evolution_byCountry"),
          fluidRow(
            column(
              uiOutput("selectize_casesByCountries"),
              width = 3,
            ),
            column(
              checkboxInput("checkbox_logCaseEvolutionCountry", label = "Logarithmic Y-Axis", value = FALSE),
              checkboxInput("checkbox_per100kEvolutionCountry", label = "Per Population", value = FALSE),
              width = 3,
              style = "float: right; padding: 10px; margin-right: 50px"
            )
          ),
          width = 6
        ),
        box(
          title = "\u0053\u1ed1\u0020\u0063\u0061\u0020\u006b\u1ec3\u0020\u0074\u1eeb\u0020\u006e\u0067\u00e0\u0079\u0020\u0063\u00f3\u0020\u0063\u0061\u0020\u0074\u0068\u1ee9\u0020\u0031\u0030\u002f\u0031\u0030\u0030",
          plotlyOutput("case_evolution_after100"),
          fluidRow(
            column(
              uiOutput("selectize_casesByCountriesAfter100th"),
              width = 3,
            ),
            column(
              uiOutput("selectize_casesSince100th"),
              width = 3
            ),
            column(
              checkboxInput("checkbox_logCaseEvolution100th", label = "Logarithmic Y-Axis", value = FALSE),
              checkboxInput("checkbox_per100kEvolutionCountry100th", label = "Per Population", value = FALSE),
              width = 3,
              style = "float: right; padding: 10px; margin-right: 50px"
            )
          ),
          width = 6
        )
      ),
      fluidRow(
        box(
          title = "\u0054\u1ec9\u0020\u006c\u1ec7\u0020\u0064\u006f\u0075\u0062\u006c\u0065\u0020\u0074\u0069\u006d\u0065\u0073\u0020\u0063\u1ee7\u0061\u0020\u0073\u1ed1\u0020\u0063\u0061\u0020\u0074\u1eeb\u006e\u0067\u0020\u0071\u0075\u1ed1\u0063\u0020\u0067\u0069\u0061",
          plotlyOutput("plot_doublingTime"),
          fluidRow(
            column(
              uiOutput("selectize_doublingTime_Country"),
              width = 3,
            ),
            column(
              uiOutput("selectize_doublingTime_Variable"),
              width = 3,
            ),
            column(width = 3),
            column(
              div("Note: \u0054\u1ec9\u0020\u006c\u1ec7\u0020\u006e\u00e0\u0079\u0020\u0111\u01b0\u1ee3\u0063\u0020\u0074\u00ed\u006e\u0068\u0020\u0064\u1ef1\u0061\u0020\u0074\u0072\u00ea\u006e\u0020\u0037\u0020\u006e\u0067\u00e0\u0079\u0020\u0067\u1ea7\u006e\u0020\u006e\u0068\u1ea5\u0074.",
                style = "padding-top: 15px;"),
              width = 3
            )
          )
        )
      )
    )
  )
)

page_plots <- dashboardPage(
  title   = "Plots",
  header  = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body    = body_plots
)