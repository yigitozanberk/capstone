## Returns a two column data.table of predicted ngrams that are the
## acquired by using the algorithm. If the entered data.table is empty
## then an empty data.table is returned.
##
## my.ngram - 2 column data.table. The first column: ngram,
##            contains all the predicted trigrams, bigrams or unigrams
##            together with their associated probability scores
getAdjNgram = function(my.ngram) {
        samp = strsplit(my.ngram[1,ngram], split = "_")
        if(length(samp[[1]]) == 3) {
                my.ngram$ngram = str_split_fixed(my.ngram$ngram, "_", 3)[, 3]
                return(my.ngram)
        } else if(length(samp[[1]]) == 2) {
                my.ngram$ngram = str_split_fixed(my.ngram$ngram, "_", 2)[, 2]
                return(my.ngram)
        } else return(my.ngram)
}

## Returns a two column data.table of predicted ngrams that are the
## acquired by using the algorithm. If the entered data.table is empty
## and the input expression is not observed, returns an empty data.table
##
## bigPre - cleaned user input.
## unigs - 2 column data.table. The first column : ngram, contains all 
##            the unigrams observed in the training corpus

getSQLFinalProbs = function(bigPre, unigs) {
        ID = integer()
        querry = paste("SELECT * FROM trigs WHERE ngram like '", 
                       bigPre, "_%' ORDER BY freq DESC", sep = "")
        my.dat = as.data.table(sqldf(querry))
        if(nrow(my.dat) < 1) {
                my.dat = getSQLBigProbs(bigPre, bigrs)
                if(nrow(my.dat) < 1) {
                        my.dat = getUnigProbs(unigs)[, freq := freq * 0.16]
                        return(my.dat)
                } else {
                        my.dat = my.dat[, freq := freq * 0.4]
                        return(my.dat)}
        } else {
                return(my.dat)
        }
}

## Returns a two column data.table of predicted trigrams that are the
## acquired by using the algorithm. If the entered data.table is empty
## and the input expression is not observed, returns an empty data.table
##
## bigPre - cleaned user input.
## trigrams - 2 column data.table. The first column : ngram, contains all 
##            the unigrams observed in the training corpus

getSQLTrigProbs = function(bigPre, trigrams) {
        querry = paste("SELECT * FROM trigs WHERE ngram like '", 
                       bigPre, "_%' ORDER BY freq DESC", sep = "")
        my.dat = as.data.table(sqldf(querry))
        w_i_1 <- str_split(bigPre, "_")[[1]][2]
        querry = paste("SELECT * FROM bigrs WHERE ngram like '",
                       w_i_1, "_%' ORDER BY freq DESC", sep = "")
        my.dat.bigs = as.data.table(sqldf(querry))
        total_count = my.dat.bigs[, sum(freq)]
        my.dat = my.dat[ , freq := freq / total_count]
        return(my.dat)
}

## Returns a two column data.table of predicted bigrams that are the
## acquired by using the algorithm. If the entered data.table is empty
## and the input expression is not observed, returns an empty data.table
##
## bigPre - cleaned user input.
## bigrams - 2 column data.table. The first column : ngram, contains all 
##            the unigrams observed in the training corpus
getSQLBigProbs = function(bigPre, bigrams) {
        w_i_1 <- str_split(bigPre, "_")[[1]][2]
        querry = paste("SELECT * FROM bigrs WHERE ngram like '",
                       w_i_1, "_%' ORDER BY freq DESC", sep = "")
        my.dat = as.data.table(sqldf(querry))
        querry = paste("SELECT * FROM unigsFull WHERE ngram like '",
                       w_i_1, "' ORDER BY freq DESC", sep = "")
        my.dat.unig = as.data.table(sqldf(querry))
        total_count = my.dat.unig[, sum(freq)]
        my.dat = my.dat[, freq := freq/total_count]
        return(my.dat)
}

## Returns a two column data.table of predicted unigrams that are the
## acquired by using the algorithm. If the entered data.table is empty
## and the input expression is not observed, returns an empty data.table
##
## unigs - 2 column data.table. The first column : ngram, contains all 
##            the unigrams observed in the training corpus
getUnigProbs = function(unigrams) {
        #probs = unigrams %>% rename(prob = freq) %>%
        #    mutate(prob = prob/sum(prob)) %>%
        #    arrange(desc(prob), ngram)
        probs = data.table(unigrams)
        total_count = probs[, sum(freq)]
        probs = probs[order(freq, decreasing = T)][1:50][, freq := freq/total_count]
        return(probs)
}

## cleans the input text into required format and outputs text
## in the form w1_w2_w3, w1_w1, or w1. 
## Maximum format is with 3 words.
## 
## inputWords - user input text
wordSplitter = function(inputWords) {
        s.words = unlist(strsplit(inputWords, "[ !?.]+"))
        count = length(s.words)
        bigPre = character()
        if(count >= 2) {
                bigPre = paste(s.words[count-1],
                               s.words[count], sep = "_")
                return(bigPre)
        } else {
                bigPre = s.words
                return(bigPre)
        }
}








### SERVER CODE

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
library(sqldf)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
        
        ## load the ngram databases extracted from twitter corpus
        #load("unigsFull.rda")
        #load("unigs.rda")
        #load("bigrs.rda")
        #load("trigs.rda")
        source("getAdjNgram.R")
        source("getSQLFinalProbs.R")
        source("getSQLTrigProbs.R")
        source("getSQLBigProbs.R")
        source("getUnigProbs.R")
        source("wordSplitter.R")
        mypred <- vector(mode = "character", length = 0 )
        
        modelpred <- reactive({
                in.words <- input$InputText
                bigPre <- wordSplitter(in.words)
                pred <- getSQLFinalProbs(bigPre, unigs)
                pred.words <- getAdjNgram(pred)
                return(pred.words)
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
                str9 <- "ui.R code: https://github.com/yigitozanberk/Developing_Data_Products/blob/master/DDP_Final/ui.R"
                str10 <- ""
                str11 <- "server.R code: https://github.com/yigitozanberk/Developing_Data_Products/blob/master/DDP_Final/server.R"
                str12 <- ""
                HTML(paste(str1, str2, str3, str4, str5, str6, str7, str8, str9, str10, str11, 
                           str12, sep = '<br/>'))
        })
        
})
