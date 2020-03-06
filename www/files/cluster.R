bandera2 <- exists('dataset')
if(bandera2){
  #se convierte a matriz
  tfidf.matrix <- as.matrix (dataset)
  
  library(philentropy)
  dist.matrix = distance(tfidf.matrix, method = "euclidean")
  
  
  # Preparación set de datos.
  
  dist.matrix <- as.data.frame(dist.matrix)
  
  set.seed(80)
  
  
  datos_tuits <- kmeans(dist.matrix, centers = num_cluster)
  
  k <- datos_tuits$cluster #asignación observaciones a clusters
  
  data_inicio <- as.data.frame(cbind(tweet=df2$text,cluster=k))
  
  count_clusters <- as.data.frame(table(data_inicio$cluster))
  colnames(count_clusters)[1]<-'Clusters'
}
