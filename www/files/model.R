
# var_bandera_clean_text -> found in preprocessingText file
# valida si se realizo la limpieza a la columna text

if(exists('var_bandera_clean_text')){
  
  if(tweetsIdioma == "en"){
    
    tSparse_Modelo <- read.csv("www/files/files_csv/modelo/en/tSparse_Modelo.csv",header = TRUE, sep = ",",encoding = "Windows-1252")
     
    #load model train
    load(file = "www/files/files_csv/modelo/en/model.rda")
    
  }else if(tweetsIdioma == "es"){
    
    tSparse_Modelo <- read.csv("www/files/files_csv/modelo/es/tSparse_Modelo.csv",header = TRUE, sep = ",",encoding = "Windows-1252")
    
    #load model train
    #load(file = "www/files/files_csv/modelo/es/model_randomForest.rda")
    
  }
  # Create the Text Corpus
  corpus_descarga = Corpus(VectorSource(df_search_Clean$text))
  
  # Create Document Term Matrix
  # 'select_text' found in preprocessingText file
  frequencies_descarga = DocumentTermMatrix(corpus_descarga)
  
  sparse_descarga = removeSparseTerms(frequencies_descarga, 0.995)
  
  tSparse_descarga = as.data.frame(as.matrix(sparse_descarga))
  
  # se crea una matriz con ceros con el mismo número de filas de 'df_search_Clean' y columnas de tSparse_Modelo 
  new_matrix <- matrix(0, nrow(tSparse_descarga), ncol(tSparse_Modelo))
  
  # se agrega nombres
  colnames(new_matrix) <- names(tSparse_Modelo)
  
  # proceso para verificar que palabras existen de los tweets descargados en el modelo ya entrenado.
  i <- 1
  contador <- 1
  condition_1 <- TRUE
  condition_2 <- TRUE
  
  while(condition_1){
    
    # true/ false: mayores a 1 -> TRUE
    true_false <- as.data.frame(tSparse_descarga[i,]>=1)
    
    # seleccionar solo TRUE
    select_true <- true_false[which(true_false == TRUE)]
    
    # si no existe valores TRUE, pasa a la siguiente fila
    if(dim(select_true)[2]== 0){
      i <- i + 1
      condition_2 <- FALSE
    }
    
    while (condition_2) {
      
      # obtener el nombre de la columna
      name_colum <- names(select_true[contador])
      
      # obtener el numero de columna para verificar si hacen match con la bolsa de palabras del modelo IA
      num_colum <- match(name_colum, names(tSparse_Modelo))
      
      
      # verificar si existe en la bolsa de palabras del modelo
      if(!is.na(num_colum)){
        # se agrega el valor a la nueva matrix
        new_matrix [i,num_colum] <- tSparse_descarga[i,match(name_colum, names(tSparse_descarga))]
        contador <- contador + 1
      }else{
        contador <- contador + 1
      }
      # verifica si ya recorrio todas las palabras de select_true
      if(contador >= ncol(select_true) ){
        i <- i + 1
        contador <- 1
        condition_2 <- FALSE
      }
      
    }
    condition_2 <- TRUE
    
    if(i >= nrow(tSparse_descarga) ){
      condition_1 <- FALSE
    }
  }
  new_matrix <- data.frame(new_matrix)
  
  # Predicting on new_matrix set
  predValid_ <- predict(model, new_matrix, type = "class")
  
  #View(predValid_)
  
  new_matrix$sentiment <- predValid_
  
  # Checking classification accuracy
  #acc <- mean(predValid_ == new_matrix$sentiment)
  
  resultados <- table(predValid_,new_matrix$sentiment)
  
  tw_neutral <- "0"
  
  tw_negatives <- sum(resultados[1,1],resultados[1,2])
  
  tw_positives <- sum(resultados[2,1],resultados[2,2])
  
  acc <- paste0(round(sum(diag(table(predValid_,new_matrix$sentiment)))/nrow(as.data.frame(predValid_))*100,2),"%")
  
  table_results <<-  data.frame(t(data.table(c(nrow(df_search_Clean),acc,tw_positives,tw_neutral,tw_negatives))))
  setattr(table_results, 'names', c('Tweets',label_acc,title_positive,title_neutral,title_negative))
  
  #location freq
  if(!is.na(number_column_location)){
    
    if(tweetsUbicacionVacia){
      #Obtener columna location
      select_location <- data.frame(df_search_Clean$location)
      colnames(select_location)[1]<-"location"
      
      #Filtar datos con location vacias.
      select_location <- select_location %>% filter(location !="")
      select_location <- select_location %>% filter(location !=" ")

      #Tabla de frecuencia location
      tabla_freq_location <- select_location %>% 
        count(location)  %>% 
        arrange(desc(n)) 

      total <- sum(tabla_freq_location$n)
      
      tabla_freq_location$porcentage <- round(tabla_freq_location$n * 100 / total,2)
      
      tabla_location <<-  tabla_freq_location %>% select(1, 3)

    }
  }
  # obtained number column hashtags
  number_column_hashtag <- match("hashtags",names(df_search_Clean))
  
  if(!is.na(number_column_hashtag)){
    if(tweetshashtags_f){
      contains_hashtags <<- TRUE
      hashtags <- data.frame(unlist(df_search_Clean$hashtags))
      names(hashtags) <- "hashtag"
      
      #Columna hashtags
      
      hashtags <- Corpus(VectorSource(hashtags$hashtag))
      hashtags <- clean_hashtags(hashtags)
      #Generar tabla de freq
      dtm <- TermDocumentMatrix(hashtags)
      m <- as.matrix(dtm)
      v <- sort(rowSums(m),decreasing = TRUE)
      
      tabla_hashtag <<- data.frame(word = names(v),freq = v)
      
      row.names(tabla_hashtag) <- NULL
      
      }else{
      contains_hashtags <<- FALSE
    }

  }
  
}else{
  cat("Aplique preprocesaminto")
}


