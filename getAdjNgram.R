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