bandera <- exists('df_search_API')


if(bandera){
  
  if(language=="es"){
    detectIdioma <- "es"
  }else{
    detectIdioma <- "en"
  }
  
  #clean data
  
  tweets <- iconv(df_search_API$text, "latin1", "ASCII", sub="")
  
  #remove special characters to text column
  trash <- c("<U","#","&amp","@")
  i <- 1
  continue <- TRUE
  while(continue) {
    v <- trash[i]
    v <- paste(v,'\\S+\\s*',sep = "")
    select_text <-  str_trim(gsub(v," ", tweets))
    i <- i + 1
    if(i > length(trash)){
      continue <- FALSE
    }
  }
  
  
  # function eliminate links
  removeURL <- function(x) gsub("http[^[:space:]]*", "", x)
  
  # function to clean a corpus
  
  clean_corpus <- function(string, sparse) {
    # GOAL: transform a string to corpus, clean it, and return a tibble
    
    # create the corpus
    corpus <- Corpus(VectorSource(x = string))
    
    # we are going to elimiate emails
    corpus <- tm_map(x= corpus, FUN = replace_email)
    
    # eliminate links
    corpus <- tm_map(x= corpus, removeURL)
    
    # eliminate characters
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[,]+', replacement = '')
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[™]+', replacement = '')
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[’]+', replacement = "'")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[—]+', replacement = " ")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[“]+', replacement = " ")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[”]+', replacement = " ")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[–]+', replacement = " ")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[…]+', replacement = " ")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[·]+', replacement = "")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[€]+', replacement = " ")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[,]+', replacement = "")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[(]+', replacement = "")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[)]+', replacement = "")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[<]+', replacement = "")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[>]+', replacement = "")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[_]+', replacement = "")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[•]+', replacement = "")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[´]+', replacement = "'")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = '[°]+', replacement = "")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = "[']+", replacement = "")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = "[£]+", replacement = "")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = "[…]+", replacement = "")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = "[”]+", replacement = "")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = "[•]+", replacement = "")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = "[‘]+", replacement = "")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = "[–]+", replacement = "")
    
    corpus <- tm_map(x = corpus,FUN = content_transformer(gsub), pattern = "[’]+", replacement = " ")
    
    # put to lower all the variables
    corpus <- tm_map(x = corpus, FUN = content_transformer(tolower))
    
    # now we are going to eliminate any number inside the text
    corpus <- tm_map(x = corpus, FUN = removeNumbers)
    
    # we are going to elimiate puntuation signs
    corpus <- tm_map(x = corpus, FUN = removePunctuation)
    
    # remove articles 
    #corpus <- tm_map(corpus, FUN = removeWords, stopwords(kind = "en"))
    corpus <- tm_map(corpus, FUN = removeWords, stopwords(kind = detectIdioma))
    
    
    # we will apply the steaming to find the root word
    corpus <- tm_map(corpus, FUN = stemDocument)
    
    # eliminate extra spaces 
    corpus <- tm_map(corpus, FUN = stripWhitespace)
    
    # using the corpus, we are going to build the "bag of words"
    dtm <- DocumentTermMatrix(x = corpus)
    
    # now we will reduce the words that appear few times, in order ro reduce its 
    # sparsity
    dtm <- removeSparseTerms(x = dtm, sparse = sparse) # we keep the 999% of most frequent
    # words
    
    # we will transform it as a dataframe
    dataset <- as_tibble(as.matrix(dtm))
    
    # return the corpus
    return(dataset)
  }
  
  
  dataset <- clean_corpus(string = select_text, sparse = 0.995)
  
  
}


