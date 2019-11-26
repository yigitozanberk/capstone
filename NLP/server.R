#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(quanteda)
library(dplyr)
library(stringr)
library(wordcloud)
library(data.table)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    ## load the ngram databases extracted from twitter corpus
    load("unigsFull.rda")
    load("unigs.rda")
    load("bigrs.rda")
    load("trigs.rda")
    source("getAdjNgram.R")
    source("getSQLFinalProbs.R")
    source("getSQLTrigProbs.R")
    source("getSQLBigProbs.R")
    source("getUnigProbs.R")
    source("wordSplitter.R")
    

    modelpred <- reactive({
        in.words <- input$InputText
        bigPre <- wordSplitter(in.words)
        pred <- getSQLFinalProbs(bigPre, unigs)
        pred.words <- getAdjNgram(pred)
        return(pred.words)
    })
    
    output$pred1 <- renderText({
        modelpred()[1]
    })
    
    
    output$wordPlot <- renderPlot({


    })
    
    output$documentation <- renderUI({
        str1 <- "Data Source: Coursera Capstone Project Twitter Data"
        str2 <- ""
        str3 <- "Input: Type any word(s)"
        str4 <- ""
        str5 <- ""
        str6 <- ""
        str7 <- "Output: Top 5 predicted words"
        str8 <- "Output: Top associated words as wordcloud image"
        str9 <- "ui.R code: https://github.com/yigitozanberk/Developing_Data_Products/blob/master/DDP_Final/ui.R"
        str10 <- ""
        str11 <- "server.R code: https://github.com/yigitozanberk/Developing_Data_Products/blob/master/DDP_Final/server.R"
        str12 <- ""
        HTML(paste(str1, str2, str3, str4, str5, str6, str7, str8, str9, str10, str11, 
                   str12, sep = '<br/>'))
    })

})
