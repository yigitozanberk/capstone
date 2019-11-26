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