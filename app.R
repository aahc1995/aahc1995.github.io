

# libraries
source("www/files/libraries.R")

source("www/files/indicator/helpers.R")


# Define UI for application 

body <- dashboardBody(
  fluidRow(
    column(width = 12,
           box(
             title = "Tweets", width = NULL, status = "primary",
             hr(),
             textOutput("nowRegistrosTuits"),
             hr(),
             div(style = 'height:540px;overflow-x: scroll', DT::dataTableOutput("mytable"))
           )
    ),
    column(3, align="right", offset = 9, downloadButton('downloadData',uiOutput('btn_download'),class = "btn_download_search"))
    
    #,tags$style(type='text/css', "#downloadData { width:100%; margin-top: 5px}")
  )
)

tablaLimpiezaDatos <- dashboardBody(
  fluidRow(
    column(width = 12,
           box(
             title = uiOutput("title_tlimpieza") , width = NULL, status = "primary",
             hr(),
             textOutput("nowRegistros2"),
             hr(),
             div(style = 'height:540px;overflow-x: scroll', DT::dataTableOutput("tablaLimpiezaDatos"))
           )
    ),
    column(3, align="right", offset = 9, downloadButton('downloadDataLimpiezaDatos', uiOutput('btn_download_clean')))
  )
)
tablaCombinaFiles <- dashboardBody(
  fluidRow(
    column(width = 12,
           box(
             title = uiOutput("title_tCombinaFiles"), width = NULL, status = "primary",
             hr(),
             textOutput("nowRegistros"),
             hr(),
             div(style = 'height:540px;overflow-x: scroll', DT::dataTableOutput("preViewCombinaDatos"))
             
           )
    ),
    column(3, align="right", offset = 9, downloadButton('downloadDataCombinaDatos',  uiOutput('btn_download_rbind')))
  )
)

modelo_IA <- dashboardBody(
  div(class="result",h3(uiOutput("label_result"))),

  panel(
  fluidRow(
    column(width = 12,align="center",
           box(
            title = uiOutput("label_result_sa"), width = NULL, status = "primary",
            tableOutput('t_modelo_IA') ,
            #div(style = 'overflow-x: scroll', tableOutput('t_modelo_IA'))
            # Horizontal line ----
            tags$hr()
           )
    ),
    column(width = 6,align="center",
           box(
             title = uiOutput("label_result_frehash"), width = NULL, status = "primary",
             div(style = 'height:540px; width:350px; overflow-x: scroll', DT::dataTableOutput("t_hashtag"))
           ),
           # Horizontal line ----
           tags$hr()
    ),
    column(width = 6,align="center",
           box(
             title = uiOutput("label_result_country") , width = NULL, status = "primary",
             #div(style = 'overflow-x: scroll', DT::dataTableOutput("t_location"))
             div(style = 'height:540px;overflow-x: scroll', DT::dataTableOutput("t_location"))
             
           ),
           # Horizontal line ----
           tags$hr()
    )
    ,
    # Horizontal line ----
    tags$hr()
  )

))

#b64 <- base64enc::dataURI(file="nube.jpeg", mime="image/png")
ui <- fluidPage(
  
  #call style
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/style.css"),
    tags$link(rel="shortcut icon", href="images/favicon.ico")
  ),

  # useShinyjs - enable/disabled input
  useShinyjs(),

  
  theme = shinytheme("flatly"),

  navbarPage(
    title="SASTuit",
    id = "navbar",
    collapsible=TRUE, 
    tabPanel(title = uiOutput("title_panel_inicio"),
             HTML('<center><img src="images/sastuit_emoji.jpg"  alt="sastuit"></center>')
    ),
    tabPanel(title = uiOutput("title_panel_dtweets"),
             panel(
               
               # Application title
               
               titlePanel(title =uiOutput("titulo_panel_main")),
               sidebarPanel(
                 actionButton("apiKeys", "API keys",class = "button"),
                 
                 h4(textInput("txtHashTag", label = h4(uiOutput("labelHashTag")), value = "")),
                 
                 # Horizontal line ----
                 tags$hr(),
                 
                 h4(prettyCheckbox(inputId = "retweet", label = "Retweet",
                                   thick = TRUE,fill = TRUE,bigger = TRUE, icon = icon("check"))),
                 
                 # Horizontal line ----
                 tags$hr(),
                 
                 h4(prettyCheckbox(inputId = "ratelimit", label = "Rate limit",
                                   thick = TRUE,fill = TRUE,bigger = TRUE, icon = icon("check"))),
                 
                 
                 h4(numericInput("numLimite", label = h4(uiOutput("labelnumLimite")), value = 10)),
                 
                 
                 h4(selectInput("selectIdioma", label = h4(uiOutput("labelselectIdioma")), 
                                choices = list("-"='-',"ANYWHERE" = 'FALSE',"ES" = 'es', "EN" = 'en'), 
                                selected = 1)),
                 
                 h4(numericInput("max_id", label = h4("Max status_id"), value = "")),
                 
                 #dateInput("dateTuit", label = h3("Fecha"), value = "2019-01-01"),
                 withBusyIndicatorUI(
                 actionButton("sent", label = uiOutput("labelsent") ,class = "button"))#,
                 
                 
               ),
               mainPanel(
                 body
               )
               
             ),
             HTML('<center><img src="images/sastuit.jpg"  alt="sastuit"></center>')
    ),
    tabPanel(title = uiOutput("title_panel_bind_files"),
             panel(
               titlePanel(title = uiOutput("title_panel_main_file")),
               sidebarPanel(
                 h4(fileInput("csvs",label = h4(uiOutput("labelUploadFiles")), multiple = TRUE,
                              accept = c(
                                ".csv"))),
                 
                 
                 h4(selectInput("selectIdiomaCombina", label = h4(uiOutput("labelselectIdiomaCombina")), 
                                choices = list("-"='-',"ES" = 'es', "EN" = 'en'), 
                                selected = 1)),
                 withBusyIndicatorUI(
                  actionButton("combinaFiles", uiOutput("btn_label_rbind"), class = "button")
                 ),
                 mainPanel()
               ),
               mainPanel(
                 tablaCombinaFiles
               )
             ),
             HTML('<center><img src="images/sastuit.jpg"  alt="sastuit"></center>')),
    tabPanel(title = uiOutput("title_panel_cleaningData"),
             panel(
               titlePanel(title =uiOutput("titulo_panel_main_clean")),
               sidebarPanel(
                 
                 column(width = 12,align="center",
                        h2(uiOutput("title_filters"))
                 ),
                
                 
                 h4(selectInput("selectIdiomaLimpieza", label = h4(uiOutput("title_language_clean")), 
                                choices = list("-"='-',"ES" = 'es', "EN" = 'en'), 
                                selected = 1)),
                 # Horizontal line ----
                 tags$hr(),
                 
                 h4(prettyCheckbox("twImgPerfil", label = uiOutput("title_img_profile"),
                                   thick = TRUE,fill = TRUE,bigger = TRUE, icon = icon("check"))),
                 
                 # Horizontal line ----
                 tags$hr(),

                 h4(prettyCheckbox(inputId = "twImgPortada", label = uiOutput("title_profilebanners"),
                                   thick = TRUE,fill = TRUE,bigger = TRUE, icon = icon("check"))),
                 # Horizontal line ----
                 tags$hr(),
                 
                 h4(prettyCheckbox(inputId = "twUbicacionVacia", label = uiOutput("title_location"),
                                   thick = TRUE,fill = TRUE,bigger = TRUE, icon = icon("check"))),
                 
                 # Horizontal line ----
                 tags$hr(),
                 
                 h4(prettyCheckbox(inputId = "twhashtags_f", label = uiOutput("title_hashtagF"),
                                   thick = TRUE,fill = TRUE,bigger = TRUE, icon = icon("check"))),
                 
                 # Horizontal line ----
                 tags$hr(),
                 
                 h4(sliderInput("longtext", label = h4(uiOutput("title_longtext")), min = 0, 
                             max = 280, value = 0)),
                 

                 
                 h4(fileInput("csvs_stopwords",label = h4(uiOutput("title_stopwords")), multiple = FALSE,
                              accept = c(
                                ".csv"))),
                 
                 actionButton("limpieza", uiOutput("title_btn_clean"),class = "button")
                 
               ),
               mainPanel(
                 tablaLimpiezaDatos
               )
             ),
             HTML('<center><img src="images/sastuit.jpg"  alt="sastuit"></center>')
    ),
    tabPanel(title = uiOutput("title_panel_prediction"),
             panel(
               titlePanel(
                 div(class="title_panel_predict_",uiOutput("title_panel_predict_"))),
               sidebarPanel(
                 div(class="title_panel_model",h2(uiOutput("title_panel_model"))),
                # h3(uiOutput("title_panel_model")),
                 
               #  h4(fileInput("csvs_prueba",label = h4("Cargar archivos"), multiple = TRUE,
              #                accept = c(
              #                ".csv"))),

                      withBusyIndicatorUI(
                        actionButton('btn_modelo_IA', uiOutput("btn_title_model"),class = "button")
                      )
               ),
               mainPanel(
                 modelo_IA
               )
             ),
             HTML('<center><img src="images/sastuit.jpg"  alt="sastuit"></center>')

    ),
    navbarMenu(title=uiOutput("title_panel_language"),
               tabPanel("EN",             
                        HTML('<center><img src="images/sastuit_emoji.jpg"  alt="sastuit"></center>')
               ),
               tabPanel("ES",
                        HTML('<center><img src="images/sastuit_emoji.jpg"  alt="sastuit"></center>')
               )
    )
  )
)

server <- function(input, output,session) {
  
  # call file functions
  source("www/files/funciones.R")
  
  # max size file upload csv: 1gb
  (shiny.maxRequestSize=1000*1024^2)
  options(shiny.maxRequestSize = 1000*1024^2)
 
  # default variables
  var_lang_sent <<- FALSE
  var_lang_CombinaFiles <<- FALSE
  var_bandera_clean_text <<- FALSE
  
  #-----------------------------------------------------------------------------
  # change language
  
  # select language EN default
  updateTabsetPanel(session, "navbar",selected = "EN")
  source("www/files/en.R")
  
  observeEvent(input$navbar, {
    
    if (input$navbar == "EN"){
      # call files in EN
      source("www/files/en.R")
    }else if(input$navbar == "ES"){
      # call files in ES
      source("www/files/es.R")
    }

    # ---------------------------------------------------------------
    # name menu Home
    
    # title_panel_inicio
    output$title_panel_inicio = renderText({
      title_panel_inicio_
    })
    # ---------------------------------------------------------------
    
    # ---------------------------------------------------------------
    # name menu Download tweets
    
    # title SASTuit
    output$titulo_panel_main = renderText({
      HTML(paste0("<b>",titulo_panel_main_,"</b>"))
    })
    # labelHashTag
    output$labelHashTag = renderText({
      labelHashTag_
    })
    # labelnumLimite
    output$labelnumLimite = renderText({
      labelnumLimite_
    })
    # labelselectIdioma
    output$labelselectIdioma = renderText({
      title_panel_language_
    })
    # labelsent
    output$labelsent = renderText({
      labelsent_
    })
    # title_panel_dtweets table
    output$title_panel_dtweets = renderText({
      title_panel_dtweets_
    })
    # title number row
    output$nowRegistrosTuits <- renderText({
      
      if(exists('num_nrowDf_search')){
        paste(nowrows_, num_nrowDf_search)
      }else{
        paste(nowrows_, "0")
      }
    })
    # btn_download
    output$btn_download = renderText({
      btn_download_
    })
    # ---------------------------------------------------------------
    
    # ---------------------------------------------------------------
    # name menu Bind files
    # title SASTuit
    output$title_panel_main_file = renderText({
      HTML(paste0("<b>",titulo_panel_main_,"</b>"))
    })
    # title_panel_bind_files
    output$title_panel_bind_files = renderText({
      title_panel_bind_files_
    })
    # labelUploadFiles
    output$labelUploadFiles = renderText({
      labelUploadFiles_
    })
    # labelselectIdiomaCombina
    output$labelselectIdiomaCombina = renderText({
      title_panel_language_
    })
    # btn_label_rbind
    output$btn_label_rbind = renderText({
      btn_label_rbind_
    })
    # title_tCombinaFiles table
    output$title_tCombinaFiles = renderText({
      title_tlimpieza_
    })
    # btn_download_rbind
    output$btn_download_rbind = renderText({
      btn_download_
    })
    # title number row
    output$nowRegistros <- renderText({
      if(exists('nrow_Panelcombina')){
        paste(nowrows_, nrow_Panelcombina)
      }else{
        paste(nowrows_, "0")
      }
    })
    # ---------------------------------------------------------------
    
    # ---------------------------------------------------------------
    # name menu Text data cleaning
    # # title SASTuit
    output$titulo_panel_main_clean = renderText({
      HTML(paste0("<b>",titulo_panel_main_,"</b>"))
      
    })
    # title_panel_cleaningData
    output$title_panel_cleaningData = renderText({
      title_panel_cleaningData_
    })
    # title_filters
    output$title_filters = renderText({
      HTML(paste0("<b>",title_filters_,"</b>"))
    })
    # title_img_profile
    output$title_img_profile = renderText({
      #HTML(paste0("<b>",title_img_profile_,"</b>"))
      title_img_profile_
    })
    # title_profilebanners
    output$title_profilebanners <- renderText({
      title_profilebanners_
    })
    # title_location
    output$title_location <- renderText({
      title_location_
    })
    # title_hashtagF
    output$title_hashtagF <- renderText({
      title_hashtagF_
    })
    # title_longtext
    output$title_longtext <- renderText({
      title_longtext_
    })
    # title_stopwords
    output$title_stopwords <- renderText({
      title_stopwords_
    })
    # title_btn_clean
    output$title_btn_clean <- renderText({
      title_btn_clean_
    })
    # title_language_clean
    output$title_language_clean = renderText({
      title_panel_language_
    })
    # title_tlimpieza
    output$title_tlimpieza = renderText({
      title_tlimpieza_
    })
    # title number row 
    output$nowRegistros2 <- renderText({
      if(exists('df_search_Clean')){
        paste(nowrows_,  nrow(df_search_Clean))
      }else{
        paste(nowrows_, "0")
      }
    })
    # btn_download_clean
    output$btn_download_clean = renderText({
      btn_download_
    })
    # ---------------------------------------------------------------
    
    # ---------------------------------------------------------------
    # name menu Prediction
    # title_panel_predict_
    output$title_panel_predict_ = renderText({
      titulo_panel_main_
    })
    # title_panel_prediction - menu
    output$title_panel_prediction = renderText({
      title_panel_prediction_
    })
    # title_panel_model
    output$title_panel_model = renderText({
      title_panel_model_
    })
    # label_result
    output$label_result = renderText({
      label_result_
    })
    # label_result_sa
    output$label_result_sa = renderText({
      label_result_sa
    })
    # label_result_frehash
    output$label_result_frehash = renderText({
      label_result_frehash
    })
    # label_result_country
    output$label_result_country = renderText({
      label_result_country
    })
    # btn_title_model
    output$btn_title_model = renderText({
      btn_title_model
    })
    # ---------------------------------------------------------------
    # name menu Language
    
    output$title_panel_language = renderText({
      title_panel_language_
    })
    # ---------------------------------------------------------------
  })
  #-----------------------------------------------------------------------------
  
  #-----------------------------------------------------------------------------  
  # default buttons disabled
  toggleState("downloadData")
  toggleState("downloadDataCombinaDatos")
  toggleState("downloadDataLimpiezaDatos")
  #-----------------------------------------------------------------------------
  
  #-----------------------------------------------------------------------------
  # base files show
  df_search <- read.table("www/files/files_csv/df_search_base.csv",header = TRUE, sep = ",",check.names = TRUE, encoding = "Windows-1252")
  
  result_tweets <- read.table("www/files/files_csv/result_tweets_base.csv",header = TRUE, sep = ",",check.names = F)

  df_hashtag <- read.table("www/files/files_csv/hashtagVacio.csv",header = TRUE, sep = ",",encoding = "Windows-1252")
  
  row.names(df_hashtag) <- ""
  
  df_hashtag2 <- read.csv("www/files/files_csv/hashtag.csv",header = TRUE, sep = ",",encoding = "Windows-1252")

  location_base <-  read.csv("www/files/files_csv/location_base.csv",header = TRUE, sep = ",",encoding = "Windows-1252")

  #tSparse_Modelo <- read.csv("www/files/files_csv/es/tSparse_Modelo.csv",header = TRUE, sep = ",",encoding = "Windows-1252")
  
  # print base files
  output$mytable = DT::renderDataTable({
    df_search
  })
  output$preViewCombinaDatos = DT::renderDataTable({
    df_search
  })
  output$tablaLimpiezaDatos = DT::renderDataTable({
    df_search
  })
  
  output$t_modelo_IA <- renderTable({
    result_tweets
  })
  #output$t_hashtag = DT::renderDataTable({
   # datatable(df_hashtag, options = list(dom = ''))
    
  #})
  #-----------------------------------------------------------------------------
  
  dataModal <- function(failed = FALSE) {
    modalDialog(
      title = "Enter API keys Twitter",
      #textInput("txt", "API key"),
      h4(textInput("name_app",  label = "", placeholder = 'Nombre de la APP')),
      h4(textInput("api_key",  label = "", placeholder = 'API key')),
      h4(textInput("api_secret", label = "", value = "", placeholder = 'API secret key')),
      #h4(textInput("txtHashTag", label = h4(uiOutput("labelHashTag")), value = "", placeholder = 'Access token ')),
      #h4(textInput("txtHashTag", label = h4(uiOutput("labelHashTag")), value = "", placeholder = 'Access token secret')),
      footer = tagList(
        if(exists('apiKey')){
          h4(textInput("txt",  label = "",value = apiKey, placeholder = 'API key'))
          
          sendSweetAlert(
            session = session,
            title = "Token Creado",
            text = "Ya hay",
            type = "success"
          ) 
          #verbatimTextOutput("existe")
        },
        
        modalButton("Cancel"),
        actionButton("envio", "OK")
      )
      
    )
  }
  
  observeEvent(input$apiKeys, {
    
    showModal(dataModal())
  })
  observeEvent(input$envio, {
    name_app <<- trim(input$name_app)
    api_key <<- trim(input$api_key)
    api_secret <<- trim(input$api_secret)
    if(!isTruthy(name_app)){
      sendSweetAlert(
        session = session,
        title = "¡Error!",
        text = "ingrese name_app",
        type = "error"
      ) 
      
    }else if(!isTruthy(trim(input$api_key))){
      sendSweetAlert(
        session = session,
        title = "¡Error!",
        text = "ingrese api_key",
        type = "error"
      )}else if(!isTruthy(trim(input$api_secret))){
        sendSweetAlert(
          session = session,
          title = "¡Error!",
          text = "ingrese api_secret",
          type = "error"
        ) 
      
    }
    
    else{
     # showModal(popupModal(failed = TRUE))
      removeModal()
    }
  })

  
  observeEvent(input$btn_modelo_IA, {
    # When the button is clicked, wrap the code in a call to `withBusyIndicatorServer()`
    
      if(var_bandera_clean_text){
        
        withBusyIndicatorServer("btn_modelo_IA", {
          # preprocessing column text
          source("www/files/model.R")
          
          # print dataframe
          output$t_modelo_IA <- renderTable({
            table_results
          })
          if(!is.na(number_column_location)){
            
            if(tweetsUbicacionVacia){
              output$t_location = DT::renderDataTable({
                datatable(tabla_location, options = list(searching = FALSE,paging = FALSE ))
                #DT::datatable(iris, options = list(searching = FALSE))
                #tabla_location
              })
            }else{
              output$t_location = DT::renderDataTable({
                datatable(NULL, options = list(dom = ''))
                
              })
            }
          }
          if(contains_hashtags){
            output$t_hashtag = DT::renderDataTable({
              datatable(tabla_hashtag, options = list(searching = FALSE,paging = FALSE ))
              
            })
          }else{
            output$t_hashtag = DT::renderDataTable({
              datatable(NULL, options = list(dom = ''))
            })
          }
        })
      }else{
        sendSweetAlert(
          session = session,
          title = "¡Error!",
          text = message_model,
          type = "error"
        ) 
      }
      

      
 
    
  })
  
  
  # boton combinaFiles
  observeEvent(input$combinaFiles,{
    withBusyIndicatorServer("combinaFiles", {
    req(input$csvs)
    })
    
    language <- input$selectIdiomaCombina
    
    if(language == "-"){
      sendSweetAlert(
        session = session,
        title = "¡Error!",
        text = message_language,
        type = "error"
      ) 
      
    }else{
      
      withBusyIndicatorServer("combinaFiles", {
      

      tweetsIdioma_CombinaFiles <<- language
      var_lang_CombinaFiles <<- TRUE
      

      df_search_API <<- rbindlist(lapply(input$csvs$datapath, fread),
                                use.names = TRUE, fill = TRUE)
      
      })
      
      nrow_Panelcombina <<- dim(df_search_API)[1]
      
      # obtained number column lang
      number_column_lang_pre <- match("lang",names(df_search_API))
      
      if(!is.na(number_column_lang_pre)){
       # df_search_API <- data.frame(lapply(df_search_API, as.character), stringsAsFactors=FALSE)
        
        #Seleccionar tweets en el idioma seleccionado.
        df_search_API <<- df_search_API %>% filter(lang == tweetsIdioma_CombinaFiles)
      }
      
      # imprimir dataframe
      output$preViewCombinaDatos = DT::renderDataTable({
        df_search_API
      })
      
      # habilita boton descarga
      enable("downloadDataCombinaDatos")
      
      # descargar dataframe en formato csv
      output$downloadDataCombinaDatos <- downloadHandler(
        filename = function() {
          paste("data",".csv", sep="")
        },
        content = function(file) {
          save_as_csv(df_search_API, file, prepend_ids = FALSE, na = "",
                      fileEncoding = "Windows-1252")
        }
      )
      
      output$nowRegistros <- renderText({
        
        paste(nowrows_, nrow_Panelcombina)
        
      })
    }
    
   
  })
  
  observeEvent(input$selectIdioma, {
    
    language <- input$selectIdioma

    enable("selectIdiomaLimpieza")
    
    if(language != FALSE){

      disable("selectIdiomaLimpieza")
    }
    
  })
  
  observeEvent(input$selectIdiomaCombina, {
    
    language <- input$selectIdiomaCombina

    if(language != FALSE){

      disable("selectIdiomaLimpieza")
    }
    
  })
  
  observeEvent(input$ratelimit, {
    
    ratelimit = input$ratelimit
    if(ratelimit){
      toggleState("numLimite")
      ratelimit <<- TRUE
    }else{
      enable("numLimite")
      ratelimit <<- FALSE
    }
  })
  
  observeEvent(input$limpieza,{
    
    # verifica que df_search_API exista
    bandera <- exists('df_search_API')
    
    if(bandera){
      
     if(dim(df_search_API)[1] >= 1){
       tweetsImgPerfil <<- input$twImgPerfil
       
       tweetsImgPortada <<- input$twImgPortada
       
       tweetsUbicacionVacia <<- input$twUbicacionVacia
       
       tweetshashtags_f <<- input$twhashtags_f
       
       tweetsLongitud <<- input$longtext
       
       language <- input$selectIdiomaLimpieza
       
       boolean_idioma <- FALSE
       
       if(var_lang_sent == TRUE && tweetsIdioma_sent == FALSE){
         
         if(language == "-"){
           sendSweetAlert(
             session = session,
             title = "¡Error!",
             text = message_language,
             type = "error"
           )
           boolean_idioma <- FALSE
         }else{
           tweetsIdioma <<- language
           boolean_idioma <- TRUE
         }
       }
       else if(var_lang_sent == TRUE && tweetsIdioma_sent != FALSE){
         
         tweetsIdioma <<- tweetsIdioma_sent
         boolean_idioma <- TRUE
         
       }
       if(var_lang_CombinaFiles == TRUE){
         tweetsIdioma <<- tweetsIdioma_CombinaFiles
         boolean_idioma <- TRUE
       }
       
       if(boolean_idioma){
         
         #extras_stopwords <<- ""
         
         # validar si existe un archivo para stopwords
         if(!is.null(input$csvs_stopwords))
         {
           variable_stopwords <<- TRUE
           
           inFile_stopwords <- input$csvs_stopwords
           
           upload_file_stopwords <- read.csv(inFile_stopwords$datapath,sep = ",", header = F)
           
           extras_stopwords <- as.character(upload_file_stopwords$V1)
           
           extras_stopwords <<- c(extras_stopwords, stopwords(tweetsIdioma))
           
         }else{
           extras_stopwords<<- stopwords(tweetsIdioma)
         }
         
        # call file limpiezaDatos
         source("www/files/limpiezaDatos.R")
         
         if(mensaje_columText){
           sendSweetAlert(
             session = session,
             title = "¡Error!",
             text = alert_Textdataset,
             type = "error"
           )  
         }else{
           output$tablaLimpiezaDatos = DT::renderDataTable({
             df_search_Clean
           })
           output$nowRegistros2 <- renderText({
             
             paste(nowrows_,  nrow(df_search_Clean))
             
           })
           # habilita boton descarga
           enable("downloadDataLimpiezaDatos")
           
           # descargar dataframe en formato csv
           output$downloadDataLimpiezaDatos <- downloadHandler(
             filename = function() {
               paste("data",".csv", sep="")
             },
             content = function(file) {
               save_as_csv(df_search_Clean, file, prepend_ids = TRUE, na = "",
                           fileEncoding = "Windows-1252")
             }
           )
         }
       }
     }else{
       sendSweetAlert(
         session = session,
         title = "¡Error!",
         text = alert_low_data,
         type = "error"
       )  
      }
      
    }else{
      sendSweetAlert(
        session = session,
        title = "¡Error!",
        text = alert_no_existdt ,
        type = "error"
      )  
    }      
    
    
  })
  
  dataModal <- function(failed = FALSE) {
    modalDialog(
      title = "Enter API keys Twitter",
      #textInput("txt", "API key"),
      h4(textInput("name_app",  label = "", placeholder = 'Nombre de la APP')),
      h4(textInput("api_key",  label = "", placeholder = 'API key')),
      h4(textInput("api_secret", label = "", value = "", placeholder = 'API secret key')),
      h4(textInput("acc_token", label = "", value = "", placeholder = 'acc_token')),
      h4(textInput("acc_secret", label = "", value = "", placeholder = 'acc_secret')),
      
      #h4(textInput("txtHashTag", label = h4(uiOutput("labelHashTag")), value = "", placeholder = 'Access token ')),
      #h4(textInput("txtHashTag", label = h4(uiOutput("labelHashTag")), value = "", placeholder = 'Access token secret')),
      footer = tagList(
        modalButton("Cancel"),
        actionButton("envio", "OK")
      )
      
    )
  }
  
  observeEvent(input$apiKeys, {
    
    showModal(dataModal())
  })
  observeEvent(input$envio, {
    name_app_ <<- trim(input$name_app)
    api_key <<- trim(input$api_key)
    api_secret <<- trim(input$api_secret)
    acc_token <<- trim(input$acc_token)
    acc_secret <<- trim(input$acc_secret)
    if(!isTruthy(name_app_)){
      sendSweetAlert(
        session = session,
        title = "¡Error!",
        text = "ingrese name_app",
        type = "error"
      ) 
      
    }else if(!isTruthy(trim(input$api_key))){
      sendSweetAlert(
        session = session,
        title = "¡Error!",
        text = "ingrese api_key",
        type = "error"
      )}else if(!isTruthy(trim(input$api_secret))){
        sendSweetAlert(
          session = session,
          title = "¡Error!",
          text = "ingrese api_secret",
          type = "error"
        ) 
        
      }
    
    else{
      # showModal(popupModal(failed = TRUE))
      removeModal()
    }
  })
  observeEvent(input$sent,{
    # credeciales API Twitter
    #source("www/files/createTokenApiTwitter.R")
    
    token <- create_token(
      app = name_app_,
      consumer_key = api_key,
      consumer_secret = api_secret,
      access_token = acc_token,
     access_secret = acc_secret
    )
    
   # if(rate_limit(token)[164,3] == 0){
      
  #    sendSweetAlert(
  #      session = session,
  #      title = "¡Error!",
  #      text = "Espere 15 min para volver a buscar",
  #      type = "error"
  #    ) 
  #  }else if(rate_limit()[164,3] != 0){
    
    condicion = TRUE
    
    # Se obtienen valores de los inputs
    
    txtHashTag = trim(input$txtHashTag)
    
    include_rts = input$retweet
    
    numLimite = trim(input$numLimite)
    
    language <- input$selectIdioma
    
    max_id = trim(input$max_id)
    
    
    if(!isTruthy(txtHashTag)){
      sendSweetAlert(
        session = session,
        title = "¡Error!",
        text = alert_HashTag,
        type = "error"
      )
      condicion = FALSE
    }
    else if(language == "-"){
      sendSweetAlert(
        session = session,
        title = "¡Error!",
        text = message_language,
        type = "error"
      ) 
      condicion = FALSE
    }
    
    if(numLimite <= 0 || !isTruthy(numLimite)){
      condicion = FALSE
      sendSweetAlert(
        session = session,
        title = "¡Error!",
        text = alert_numTweet,
        type = "error"
      ) 
    }
    
    if(include_rts){
      include_rts = TRUE
    }
    else{
      include_rts = FALSE
    }
    if(!isTruthy(max_id)){
      max_id = NULL
    }
    
    if(condicion){
      

      
      withBusyIndicatorServer("sent", {
        #df_rate_limit <<- rate_limit()
      
        if(language != FALSE){
          # query - busqueda tweets
          df_search <- search_tweets(
            txtHashTag,max_id = max_id, n = numLimite, lang=language, retryonratelimit = ratelimit,include_rts = include_rts, token = token 
            
          )
         
        }else{
          # query - busqueda tweets
          df_search <- search_tweets(
            txtHashTag,max_id = max_id, n = numLimite, retryonratelimit = ratelimit,include_rts = include_rts, token = token 
          )
        }
      })
      
      tweetsIdioma_sent <<- language
      var_lang_sent <<- TRUE
      
      if(dim(df_search)[1]==0){
        #errorCondition(df_search)
        sendSweetAlert(
          session = session,
          title = "¡Error!",
          text = alert_limitT,
          type = "error"
        ) 
      }
      
      # dataframe generado
      df_search <- data.table::data.table(df_search)
      
      num_nrowDf_search <<- dim(df_search)[1]
      
      # copia del dataframe generado
      df_search_API <<- df_search
      
      #numerofilas_df_search <<- dim(df_search)[1]
      
      # imprimir dataframe
      output$mytable = DT::renderDataTable({
        df_search
      })
      
      output$nowRegistrosTuits <- renderText({
        if(exists('num_nrowDf_search')){
          paste(nowrows_, num_nrowDf_search)
        }else{
          paste(nowrows_, "0")
        }
      })
      
      # habilitar boton Descargar   
      enable("downloadData")
      
      # descargar dataframe en formato csv
      output$downloadData <- downloadHandler(
        filename = function() {
          paste("data-",Sys.Date(),".csv", sep="")
        },
        content = function(file) {
          save_as_csv(df_search, file, prepend_ids = TRUE, na = "",
                      fileEncoding = "Windows-1252")
        }
      )
    }
  #}
    
  })
}

# Run the application 
shinyApp(ui = ui, server = server)

