shinyUI(pageWithSidebar(
  
  headerPanel("Fantasy Basketball Rank 13-14 Season"),
  
  sidebarPanel(
    
    checkboxGroupInput("position",
                       h4("Position"), 
                       list("Point Guard" = "PG",
                            "Point / Shooting Guard" = c("SG-PG"),
                            "Shooting Guard" = "SG",
                            "Forward" = c("F", "SF-PF", "PF-SF"),
                            "Guard / Forward" = c("G-F", "SG-SF"),
                            "Small Forward" = "SF",
                            "Power Forward" = "C-F",
                            "Center" = "C")
                       ),
    
    checkboxGroupInput("category_reg", 
                       h4("Regular Categories*"), 
                       list("3PTM" = 11,
                            "PTS" = 28,
                            "REB" = 22,
                            "AST" = 23,
                            "ST" = 24,
                            "BLK" = 25
                            )
                       ),
    
    checkboxInput("turnovers", "TOV", FALSE),
    
    checkboxGroupInput("category_pct", 
                       h4("Percentage Categories"), 
                       list("FG" = 10,
                            "FT" = 19
                            )
                      ),
    
    h4("Salary"),
    checkboxInput(inputId = "salary_option",
                  label = "Display only up to Selected Salary Limit",
                  value = FALSE
                  ),
    
    conditionalPanel(condition = "input.salary_option == true",
                     numericInput(inputId = "salary_limit",
                                  label = "Max Salary",
                                  10000000)
                    )
      
  ),
  
  mainPanel(
    tabsetPanel(
      tabPanel("Plot", plotOutput("graph", height=750)),
      tabPanel("Table", dataTableOutput("table"))
    )
  )
))
