
suppressWarnings(library(tm))
suppressWarnings(library(stringr))
suppressWarnings(library(shiny))


#Load ngram models
load("quadgram.Rdata")
load("trigram.RData")
load("bigram.Rdata")


next_word <- function(text_input) {
  
  #Remove non-english characters
  temp <- iconv(text_input, "latin1", "ASCII", sub = "")
  
  temp <-VCorpus(VectorSource(temp))
  
  #Remove white spaces
  to_space <- content_transformer(function(x, pattern) gsub(pattern, " ", x))
  
  temp <- tm_map(temp, stripWhitespace)
  
  #Remove URLs and email addresses
  temp <- tm_map(temp, to_space, "^https?://.*[\r\n]*")
  
  temp <- tm_map(temp, to_space, "\\b[A-Z a-z 0-9._ - ]*[@](.*?)[.]{1,3} \\b")
  
  # Convert all words to lowercase
  temp <- tm_map(temp, content_transformer(tolower))
  
  #Remove punctuation marks
  temp <- tm_map(temp, removePunctuation)
  
  #Remove numbers
  temp <- tm_map(temp, removeNumbers)
  
  temp <-sapply(temp, as.character) [[1]]
  if (word(temp, -1)=="") {
    temp <- substr(temp,1,nchar(temp)-1)
  } else {
    temp <- temp
  }
  #Apply ngrams models
  
  #1.Use quadgram model if match
  #2.Then trigram model
  #3.Then Bigram model
  
  temp2 <- strsplit(temp, " ")[[1]]
  
  if (length(temp2)>=3) {
    temp2 <- tail(temp2,3)
    if (identical(character(0), 
                  head(quadgram[quadgram$term1==temp2[1] 
                                & quadgram$term2==temp2[2] 
                                & quadgram$term3==temp2[3],]$term4,1))
        ) 
      {next_word(paste(temp2[2],temp2[3],sep=" "))} 
    else {
      head(quadgram[quadgram$term1==temp2[1] 
                    & quadgram$term2==temp2[2] 
                    & quadgram$term3==temp2[3],]$term4,1)} 
  } else if (length(temp2)==2) {
    temp2 <- tail(temp2,2)
    if (identical(character(0), 
                  head(trigram[trigram$term1==temp2[1] 
                                & trigram$term2==temp2[2],]$term3,1))
    ) 
    {
      next_word(temp2[2])
    } else {
      head(trigram[trigram$term1==temp2[1] 
                    & trigram$term2==temp2[2],]$term3,1)} 
  } else if (length(temp2)==1) {
    temp2 <- tail(temp2,1)
    if (identical(character(0), 
                  head(bigram[bigram$term1==temp2[1],]$term2,1))
    ) 
    {
      "the"
    } else {
      head(bigram[bigram$term1==temp2[1], ]$term2,1)} 
  }
}
  

#Call function to UI 
shinyServer(function(input, output) {
  output$prediction <- renderPrint({
    result <- next_word(as.character(input$inputString))
    result
  })
}
)