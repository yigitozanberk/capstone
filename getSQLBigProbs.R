## Returns a two column data.table of predicted bigrams that are the
## acquired by using the algorithm. If the entered data.table is empty
## and the input expression is not observed, returns an empty data.table
##
## bigPre - cleaned user input.
## unigs - 2 column data.table. The first column : ngram, contains all 
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