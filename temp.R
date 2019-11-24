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

# UODBOBigrs = unobs_bo_bigrs, unigs, alphaBig = alpha_big

UODBigrsProbs = str_split_fixed(UODBOBigrs, "_", 2)[, 2]
w_Aw_i_1 = unigs[!(unigs$ngram %in% UODBigrsProbs), ]
#dataframe with counts
UODBigrsProbs = unigs[unigs$ngram %in% w_Aw_i_1, ]
qD = sum(UODBigrsProbs$freq)
#probabilities
UODBigrsProbs = data.frame(ngram = UODBOBigrs, 
                           prob = (alphaBig * UODBigrsProbs$freq / qD))





# Profanity

library(magrittr)

samplefile <- function(filename, fraction) {
        system(paste("perl -ne 'print if (rand() < ",
                     fraction, ")'", filename), intern=TRUE)
}

tokenize <- function(v) {
        # Add spaces before and after punctuation,
        # remove repeat spaces, and split the strings
        gsub("([^ ])([.?!&])", "\\1 \\2 ", v)   %>%
                gsub(pattern=" +", replacement=" ")     %>%
                strsplit(split=" ")
}

profanity_filter <- function(tv) {
        # Takes a tokenized vector
        bad_words <- paste("([Ff][Uu][Cc][Kk]",
                           "[Dd][Aa][Mm][Nn]",
                           "[Ss$][Hh][Ii][Tt]",
                           "[Aa@][Ss$][Ss$]",
                           "[Aa@][Ss$][Ss$][Hh][Oo][Ll][Ee]",
                           "[Cc][Uu][Nn][Tt]",
                           "[Nn][Ii][Gg][Gg][Ee][Rr])", sep="|")
        
        lapply(tv, function(x) gsub(bad_words, " ", x)) %>%
                lapply(FUN=function(x) x[!x == " "])
}






## DRAFT 1 ---------------------------------------------------------------

library(data.table)
library(quanteda)
library(dplyr)
library(stringr)

getTables = function(dat, ng) {
        dat.dfm = dfm(dat, ngrams = ng, remove_punct = T, remove_numbers = T)
        dat.tbl = data.table(ngram = featnames(dat.dfm), freq = colSums(dat.dfm),
                             key = "ngram")
        dat.tbl = dat.tbl[order(ngram)]
        return(dat.tbl)
}

#set boundaries
y = list (x1 = 1:350000,
          x2 = 350001:700000,
          x3 = 700001:1050000,
          x4 = 1050001:1400000,
          x5 = 1400000:1750000,
          x6 = 1750001:2100000,
          x7 = 2100001:2360148)
#read all text
con <- file("./en_US.twitter.txt", "r") 
twit = readLines(con, skipNul = T)
close(con)

train = twit[y[[1]]]
#transform to corpus
TW <- corpus(train)
rm(con, train, twit, x)
summary(TW, 5)

#merge dfms
rbindlist(list(a, a2))[, sum(c), b]

TW = corpus(twit[y[[1]]])

unigs1 = getTables(TW, 1)
bigrs1 = getTables(TW, 2)
trigs1 = getTables(TW, 3)


TW = corpus(twit[y[[2]]])

unigs2 = getTables(TW, 1)
bigrs2 = getTables(TW, 2)
trigs2 = getTables(TW, 3)

TW = corpus(twit[y[[3]]])

unigs3 = getTables(TW, 1)
bigrs3 = getTables(TW, 2)
trigs3 = getTables(TW, 3)

TW = corpus(twit[y[[4]]])

unigs4 = getTables(TW, 1)
bigrs4 = getTables(TW, 2)
trigs4 = getTables(TW, 3)

TW = corpus(twit[y[[5]]])

unigs5 = getTables(TW, 1)
bigrs5 = getTables(TW, 2)
trigs5 = getTables(TW, 3)

TW = corpus(twit[y[[6]]])

unigs6 = getTables(TW, 1)
bigrs6 = getTables(TW, 2)
trigs6 = getTables(TW, 3)

TW = corpus(twit[y[[7]]])

unigs7 = getTables(TW, 1)
bigrs7 = getTables(TW, 2)
trigs7 = getTables(TW, 3)

unigs = rbindlist(list(unigs1, unigs2, unigs3, 
                       unigs4, unigs5, unigs6, unigs7))[, sum(freq), ngram]

bigrs = rbindlist(list(bigrs1, bigrs2, bigrs3, 
                       bigrs4, bigrs5, bigrs6, bigrs7))[, sum(freq), ngram]

trigs = rbindlist(list(trigs1, trigs2, trigs3,
                       trigs4, trigs5, trigs6, trigs7))[, sum(freq), ngram]



microbenchmark(
        getTables(TW, 1),
        getTables2(TW, 1),
        times = 10
)



TW = corpus(twit[y[[1]]])
unigs1 = getTablesRM(TW, 1)
TW = corpus(twit[y[[2]]])
unigs2 = getTablesRM(TW, 1)
TW = corpus(twit[y[[3]]])
unigs3 = getTablesRM(TW, 1)
TW = corpus(twit[y[[4]]])
unigs4 = getTablesRM(TW, 1)
TW = corpus(twit[y[[5]]])
unigs5 = getTablesRM(TW, 1)
TW = corpus(twit[y[[6]]])
unigs6 = getTablesRM(TW, 1)
TW = corpus(twit[y[[7]]])
unigs7 = getTablesRM(TW, 1)

unigs = rbindlist(list(unigs1, unigs2, unigs3, 
                       unigs4, unigs5, unigs6, unigs7))[, sum(freq), ngram]
rm(unigs1, unigs2, unigs3, unigs4, unigs5, unigs6, unigs7)
gc()
save(unigs, file = "unigs.rda")

