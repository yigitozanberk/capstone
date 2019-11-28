#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("Word Prediction Using Ngrams"),

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            textInput("InputText", "Type below:"),
            submitButton("Submit")
        ),

        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(type = "tabs", 
                        tabPanel("Prediction", 
                                 textOutput("Associated Words"),
                                 h3("Predicted Next Word(s):"),
                                 h6("(Please wait for the program to initialize in the first run)"),
                                 textOutput("pred1"),
                                 textOutput("pred2"),
                                 textOutput("pred3"),
                                 textOutput("pred4"),
                                 textOutput("pred5"),
                                 plotOutput("plot"),
                        ),
                        tabPanel("Documentation",
                                 htmlOutput("documentation"))
            )
        )
    )
))
