server <- function(input, output, session) {
  
  families = read_csv('data/families.csv')
  families = read_csv('~/Desktop/xenocanto_quiz/data/families.csv')
  df3 = NULL
  df3_choose = NULL
  df4 = NULL
  i = NULL
  j = NULL
  
  ###### all events of tab 1 - QUIZ
  output$attenzione <- renderText('Seleziona il gruppo da inserire nel quiz e premi "Download".
                                  Dopodichè premi "Next" ogni volta che vuoi ascoltare un nuovo file audio, 
                                  e "Show" per vedere la soluzione.')
  
  observeEvent(input$run, {
    selected_family = input$family
    type = input$type
    
    df = NULL
    show_modal_spinner(
      spin = 'fingerprint',
      text = 'Please wait...'
    )
    for (i in which(families$family == selected_family)) {
      genus=families$genus[i]
      specie=families$specie[i]
      call = GET(paste0("https://www.xeno-canto.org/api/2/recordings?query=", genus, "+", specie))
      dd = data.frame(fromJSON(rawToChar(call$content)))
      dd = dd[dd$recordings.q == 'A',]
      df = rbind(df, dd[sample(dim(dd)[1], min(100,dim(dd)[1])),c(6,7,11,16,18,24,25,27)])
    }
    remove_modal_spinner()
    
    df = df %>% 
      rowwise() %>% 
      mutate(call = grepl('call', recordings.type),
             song = grepl('song', recordings.type)) 
    
    if(type == 2) {
      df2 = df[which(df$song ),]
    } else if(type == 3) {
      df2 = df[which(df$call),]
    }
    else {
      df2 = df
    }
    
    df3 <<- merge(df2, families, by.x=c('recordings.gen', 'recordings.sp'), by.y=c('genus', 'specie'))
    df3 <<- df3 %>% 
      filter(family == selected_family)
    
    chances = df3 %>% 
      group_by(nome) %>% 
      summarise(numero_oss = n())
    
    df3 <<- merge(df3, chances, on = 'nome')
    
    output$table <- renderTable(chances)  
  })
  
  i=NULL
  observeEvent(input$nxt, {
    df0 <<- df3
    if (is.null(df0)) {
      showNotification("Premi download prima di ascoltare!", duration=0, type = "error")
      return()
    }
    
    i <<- sample(1:dim(df3)[1], 1, prob = 1 / df3$numero_oss)
    output$audio <- renderUI({
      tags$audio(src = df3$recordings.file[i], type = "audio/mp3", autoplay = TRUE, controls = TRUE)
    })
  })
  
  observeEvent(input$shw, {
    if (is.null(i)) {
      showNotification("Ascolta prima di guardare la soluzione", duration=0, type = "error")
      return()
    }
    
    output$solution <- renderText(paste0('La specie è: ', df3$nome[i],
                                         '. Il tipo di audio è: ', df3$recordings.type[i], 
                                         '. Data: ', df3$recordings.date[i],
                                         '. Ora: ', df3$recordings.time[i],
                                         '. Altri suoni: ', df3$recording.also[i],
                                         '. Country: ', df3$recordings.cnt[i]))
  })
  
  ###### all events of tab 2 - random choice
  
  output$attenzione_choose <- renderText('Seleziona le specie da inserire nel quiz e premi "Download". 
                                  Servono alcuni secondi a specie per preparare i dati, quindi se ne selezioni tante
                                  (o tutte) preparati ad aspettare qualche minuto (circa 7 se selezionate tutte, altrimenti
                                  son circa 3 secondi a specie).
                                  Dopodichè premi "Next" ogni volta che vuoi ascoltare un nuovo file audio, 
                                  e "Show" per vedere la soluzione.')
  
  observeEvent(input$select_all, {
    selected = sort(unlist(lapply(1:dim(families)[1], FUN = function(x) {families$nome[x]})))
    output$FirstChoice_choose <- renderUI ({ 
      checkboxGroupInput(inputId = "quiz_choice",label = h3("Select specieS"), inline = TRUE,
                         choices = sort(unlist(lapply(1:dim(families)[1], FUN = function(x) {families$nome[x]}))),
                         selected = selected
      )
    })
  })
  
  observeEvent(input$deselect_all, {
    output$FirstChoice_choose <- renderUI ({ 
      checkboxGroupInput(inputId = "quiz_choice",label = h3("Select specieS"), inline = TRUE,
                         choices = sort(unlist(lapply(1:dim(families)[1], FUN = function(x) {families$nome[x]})))
      )
    })
  })
  
  output$FirstChoice_choose <- renderUI ({ 
    checkboxGroupInput(inputId = "quiz_choice",label = h3("Select specieS"), inline = TRUE,
                       choices = sort(unlist(lapply(1:dim(families)[1], FUN = function(x) {families$nome[x]})))
    )
  })
  
  

  
  observeEvent(input$run_choose, {
    
    selected_species = input$quiz_choice
    type_choose = input$type_choose
    
    if (is.null(selected_species)) {
      showNotification("Seleziona almeno una specie!", duration=0, type = "error")
      return()
    }
    # Save the ID for removal later
    
    show_modal_spinner(
      spin = 'fingerprint',
      text = 'Please wait...'
    )
    df_choose = NULL
    for(selected_specie in selected_species) {
      genus=families$genus[which(families$nome == selected_specie)]
      specie=families$specie[which(families$nome == selected_specie)]
      call = GET(paste0("https://www.xeno-canto.org/api/2/recordings?query=", genus, "+", specie))
      dd = data.frame(fromJSON(rawToChar(call$content)))
      df_choose = rbind(df_choose, dd[sample(dim(dd)[1], min(100,dim(dd)[1])),c(6,7,11,16,18)])
    }
    remove_modal_spinner()
  
    df_choose = df_choose %>% 
      rowwise() %>% 
      mutate(call = grepl('call', recordings.type),
             song = grepl('song', recordings.type)) 
    
    if(type_choose == 2) {
      df2_choose = df_choose[which(df_choose$song ),]
    } else if(type_choose == 3) {
      df2_choose = df_choose[which(df_choose$call),]
    }
    else {
      df2_choose = df_choose
    }
    
    df3_choose <<- merge(df2_choose, families, by.x=c('recordings.gen', 'recordings.sp'), by.y=c('genus', 'specie'))
    output$ready_choose <- renderText('READY!')
  })
  
  observeEvent(input$nxt_choose, {
    if (is.null(df3_choose)) {
      showNotification("Premi download prima di ascoltare!", duration=0, type = "error")
      return()
    }

    i <<- sample(1:dim(df3_choose)[1], 1)
    output$audio_choose <- renderUI({
      tags$audio(src = df3_choose$recordings.file[i], type = "audio/mp3", autoplay = TRUE, controls = TRUE)
    })
  })
  
  observeEvent(input$shw_choose, {
    if (is.null(i)) {
      showNotification("Ascolta prima di guardare la soluzione", duration=0, type = "error")
      return()
    }
    
    output$solution_choose <- renderText(paste0('La specie è: ', df3$nome[i],
                                                '. Il tipo di audio è: ', df3$recordings.type[i], 
                                                '. Data: ', df3$recordings.date[i],
                                                '. Ora: ', df3$recordings.time[i],
                                                '. Altri suoni: ', df3$recording.also[i],
                                                '. Country: ', df3$recordings.cnt[i]))
  })

}

 