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