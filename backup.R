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

