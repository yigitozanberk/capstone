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