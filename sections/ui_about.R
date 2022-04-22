body_about <- dashboardBody(
  fluidRow(
    fluidRow(
      column(
        box(
          title = div("About this project", style = "padding-left: 20px", class = "h2"),
          column(
            "This dashboard shows recent developments of the COVID-19 pandemic. The latest
            open data on the COVID-19 spread are regularly downloaded and displayed in
            a map, summary tables, key figures and plots.",
            tags$br(),
            h3("Motivation"),
            "Various companies thought that a global crisis is an excellent opportunity to
            show case their technologies. Therefore, my idea was to show that open-source
            technologies, such as R Shiny, can be used to create a decent dashboard in few hours.
            Furthermore, the most popular COVID-19 dashboard (",
            tags$a(href = "https://coronavirus.jhu.edu/map.html", "Johns Hopkins COVID-19"), ") is styled rather
            alarmist. Therefore, a more neutral dashboard might help to dampen the already
            existing hysteria a little.",
            tags$br(),
            tags$br(),
            "Find more thoughts on this dashboard from Christoph Schoenenberger in this",
            tags$a(href = "https://medium.com/@ch.schoenenberger/covid-19-open-source-dashboard-fa1d2b4cd985",
              "Medium article"), ".",
            h3("Data download"),
            tags$ul(
              tags$li(tags$b("COVID-19 data:"), tags$a(href = "https://github.com/CSSEGISandData/COVID-19",
                "Johns Hopkins CSSE")),
              tags$li(tags$b("Population data:"), tags$a(href = "https://data.worldbank.org/indicator/SP.POP.TOTL",
                "The World Bank"), "& Wikipedia for countries which are not in World Bank data set.")
            ),
            HTML("<b>Note</b>: Johns Hopkins is not updating their data on recovered cases anymore for various
            countries. Therefore, this data is estimated as <i>(Confirmed at current date - 14 days) - deceased at
            current date)</i>, wherever no real data is available."),
            h3("Adjust, modify and fix"),
            "Hello everybody, I'm Nguyen Vu Hai from Vietnam
            I'm student of Advanced class (CNTT K18 CLC) in Infomation and comunication technology University - Thai Nguyen 
            University. This app was provided a fix in data process and translate some content into Vietnamese, I would be 
            really glad to receive a enhance, improve or opinion from anyone. Please contact me.",
            tags$a(href = "https://www.facebook.com/hai.nguyenvuhai.2001/", "Facebook"), "|",
            tags$a(href = "https://github.com/tnvuhai", "Github"), "|",
            h3("Author source"),
            "Christoph Schoenenberger | Data Scientist @",
            tags$a(href = "https://www.zuehlke.com/ch/en/", "Zuehlke Engineering"), "|",
            tags$a(href = "https://www.linkedin.com/in/cschonenberger/", "LinkedIn"), "|",
            tags$a(href = "https://twitter.com/ChSchonenberger", "Twitter"), "|",
            tags$a(href = "https://github.com/chschoenenberger/", "Github"),tags$br(),
            "If you find any bug / issue or have an idea how to improve the dashboard,
            please create an issue on ", tags$a(href = "https://github.com/chschoenenberger/covid19_dashboard/issues",
              "Github"), ". I will try to look into it as soon as possible.",
            width = 12,
            style = "padding-left: 20px; padding-right: 20px; padding-bottom: 40px; margin-top: -15px;"
          ),
          width = 6,
        ),
        width = 12,
        style = "padding: 15px"
      )
    )
  )
)

page_about <- dashboardPage(
  title   = "About",
  header  = dashboardHeader(disable = TRUE),
  sidebar = dashboardSidebar(disable = TRUE),
  body    = body_about
)