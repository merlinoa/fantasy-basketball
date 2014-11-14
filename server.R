library(shiny)
library(ggplot2)

load(file = "data/stats-cleaned-13-14.rda")


shinyServer(function(input, output) {
  
  reg_cols <- reactive({
    as.numeric(unlist(input$category_reg))
  })
  
  tov_col <- reactive({
    if (input$turnovers == TRUE) {
      26
    } else {NULL}
  })
  
  pct_cols <- reactive({
    as.numeric(unlist(input$category_pct))
  })
  
  rank <- reactive({
    
    # return sum of all non percentage categories centered and scaled
    rank_reg <- 0
    for (i in reg_cols()) {
      rank_reg <- rank_reg + 
        (stats[, i] - mean(stats[, i], na.rm = TRUE)) / sd(stats[, i], na.rm = TRUE)
    }
    
    tov <- if (input$turnovers == TRUE) {
      (stats[, 26] - mean(stats[, 26], na.rm = TRUE)) / sd(stats[, 26], na.rm = TRUE)
    } else {0}
    
    # return sum of percentage categories centered and scaled
    rank_pct <- 0
    for (j in pct_cols()) {
      rank_pct <- rank_pct +
        (stats[, j] - mean(stats[, j], na.rm = TRUE)) / sd(stats[, j], na.rm = TRUE) * 
        (stats[, (j - 1)] / mean(stats[, (j - 1)], na.rm = TRUE))
    }
    rank_reg + rank_pct - tov
  })
  
  cols <- reactive({
    c(1:7, reg_cols(), tov_col(), pct_cols(), 29, 30)
  })
  
  # subset data for position and salary
  dataset <- reactive({
    stats$rank <- rank()
    
    if (input$salary_option == TRUE) {  
      stats <- stats[stats$salary <= input$salary_limit & 
            stats$Pos %in% input$position, cols()]
      stats[order(stats$rank, decreasing = TRUE), ]
      } else {
      stats <- stats[stats$Pos %in% input$position, cols()]
      stats[order(stats$rank, decreasing = TRUE), ]
    }
    
  })
    
  output$graph <- renderPlot({
    p <- ggplot(dataset(), aes(x = salary, y = rank))
    p <- p + geom_text(aes(label = Player), size = 3.0)
    p <- p + geom_smooth()
    print(p)
  })
  
  output$table <- renderDataTable({
    data.frame(dataset())
  })
})