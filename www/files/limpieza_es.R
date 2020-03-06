# select column text 
select_text <- df_search_Clean$text

#select_text <- trans_format_text(select_text,"UTF-8","ISO-8859-1")
select_text <- iconv(select_text, "UTF-8", "ISO-8859-1", sub="")

# apply function clean_trash
select_text <- clean_trash(select_text)

select_text <- data.table(select_text)

# removing tildes
select_text[, select_text := stri_trans_general(str = select_text, 
                                                 id = "Latin-ASCII")]

#it converts to corpus 
select_text <- Corpus(VectorSource(select_text$select_text))

#function clean_text_es is applied
select_text <- clean_text_es(select_text)

# reemplaza la columna pre procesada
df_search_Clean$text  <-  as.data.frame(select_text)$text
