con <- file("./en_US.blogs.txt", "r") 
blog = readLines(con, skipNul = T)
close(con)

#takin 15% of data for memory reasons
set.seed(12345)
x = sample(899288, 1350, replace = F)

train = blog[x]

BG <- corpus(train)
rm(con, train, blog, x)
summary(BG, 5)


## usual suspects
getFreqs = function(dat, ng) {
        dat.dfm = dfm(dat, ngrams = ng, remove_punct = T, remove_numbers = T,
                      remove = stopwords("english"))
        dat.freq = docfreq(dat.dfm)
        dat.freq = dat.freq[sort(names(dat.freq))] 
        return(dat.freq)
}


getTables = function(dat, ng) {
        ngrams = getFreqs(dat = dat, ng = ng)
        ngrams_dt = data.table(ngram = names(ngrams), freq = ngrams)
        return(ngrams_dt)
}


