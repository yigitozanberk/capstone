#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    output$distPlot <- renderPlot({

        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white')

    })
    
    output$documentation <- renderUI({
        str1 <- "Data Source: Credit Card Balance Data (accessed using R Package ISLR)"
        str2 <- ""
        str3 <- "Input 1: Select balance value"
        str4 <- "Input 2: Select rating value"
        str5 <- "Input 3: Select student status"
        str6 <- ""
        str7 <- "Output: Predicted Income level of the person based on unput values"
        str8 <- ""
        str9 <- "ui.R code: https://github.com/yigitozanberk/Developing_Data_Products/blob/master/DDP_Final/ui.R"
        str10 <- ""
        str11 <- "server.R code: https://github.com/yigitozanberk/Developing_Data_Products/blob/master/DDP_Final/server.R"
        str12 <- ""
        HTML(paste(str1, str2, str3, str4, str5, str6, str7, str8, str9, str10, str11, 
                   str12, sep = '<br/>'))
    })

})
