#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(stringr)
library(wordcloud)
library(data.table)
library(sqldf)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    ## load the ngram databases extracted from twitter corpus
    load("unigs.rda")
    load("bigrs.rda")
    load("trigs.rda")
    load("unigsFull.rda")
    source("getAdjNgram.R")
    source("getSQLFinalProbs.R")
    source("getSQLTrigProbs.R")
    source("getSQLBigProbs.R")
    source("getUnigProbs.R")
    source("wordSplitter.R")
    mypred <- vector(mode = "character", length = 0 )

    modelpred <- reactive({
            withProgress({
                setProgress(message = "Processing corpus...")
                in.words <- input$InputText
                bigPre <- wordSplitter(in.words)
                pred <- getSQLFinalProbs(bigPre, unigs)
                pred.words <- getAdjNgram(pred)
                return(pred.words)
            })
        
        #in.words <- input$InputText
        #bigPre <- wordSplitter(in.words)
        #pred <- getSQLFinalProbs(bigPre, unigs)
        #pred.words <- getAdjNgram(pred)
        #return(pred.words)
    })
    
    output$pred1 <- renderText({
        modelpred()[1, ngram]
    })
    output$pred2 <- renderText({
        modelpred()[2, ngram]
    })
    output$pred3 <- renderText({
        modelpred()[3, ngram]
    })
    output$pred4 <- renderText({
        modelpred()[4, ngram]
    })
    output$pred5 <- renderText({
        modelpred()[5, ngram]
    })
    
    # Make the wordcloud drawing predictable during a session
    wordcloud_rep <- repeatable(wordcloud)
    
    output$plot <- renderPlot({
        mytab <- modelpred()
        wordcloud_rep(mytab[, ngram], mytab[, freq], scale=c(4,0.5),
                      min.freq = 0, max.words= 50,
                      color = RColorBrewer::brewer.pal(8, "Dark2"))
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
        str9 <- "ui.R code: https://github.com/yigitozanberk/capstone/blob/master/NLP/ui.R"
        str10 <- ""
        str11 <- "server.R code: https://github.com/yigitozanberk/capstone/blob/master/NLP/server.R"
        str12 <- ""
        HTML(paste(str1, str2, str3, str4, str5, str6, str7, str8, str9, str10, str11, 
                   str12, sep = '<br/>'))
    })

})
