server <- function(input, output) {
  
  families = read_csv('/Users/fghiazza/Desktop/xenocanto_quiz/data/families.csv')
  df3 = NULL
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
      df = rbind(df, dd[sample(dim(dd)[1], min(100,dim(dd)[1])),c(6,7,11,16,18)])
    }
    remove_modal_spinner()
    
    df = df %>% 
      rowwise() %>% 
      mutate(call = grepl('call', recordings.type),
             song = grepl('song', recordings.type)) 
    
    if(type == 1) {
      df2 = df[which(!df$call & df$song ),]
    } else if(type == 2) {
      df2 = df[which(df$call & !df$song ),]
    }
    else {
      df2 = df
    }
    
    df3 <<- merge(df2, families, by.x=c('recordings.gen', 'recordings.sp'), by.y=c('genus', 'specie'))
    output$table <- renderTable(data.frame(chances = unique(df3$nome)))  
  })
  
  observeEvent(input$nxt, {
    i <<- sample(1:dim(df3)[1], 1)
    output$audio <- renderUI({
      tags$audio(src = df3$recordings.file[i], type = "audio/mp3", autoplay = TRUE, controls = TRUE)
    })
  })
  
  observeEvent(input$shw, {
    output$solution <- renderText(paste0('The audio refers to ', df3$nome[i],'. The record type is ', df3$recordings.type[i]))
  })
  
  ###### all events of tab 2 - random choice
  
  output$attenzione_choose <- renderText('Seleziona le specie da inserire nel quiz e premi "Download". 
                                  Servono alcuni secondi a specie per preparare i dati, quindi se ne selezioni tante
                                  (o tutte) preparati ad aspettare qualche minuto (circa 7 se selezionate tutte, altrimenti
                                  son circa 3 secondi a specie).
                                  Dopodichè premi "Next" ogni volta che vuoi ascoltare un nuovo file audio, 
                                  e "Show" per vedere la soluzione.')
  
  output$FirstChoice_choose <- renderUI ({ 
    checkboxGroupInput(inputId = "quiz_choice",label = h3("Select specieS"), inline = TRUE,
                choices = c('TUTTI', sort(unlist(lapply(1:dim(families)[1], FUN = function(x) {families$nome[x]}))))
    )
  })
  
  observeEvent(input$run_choose, {
    selection = input$quiz_choice
    if (selection == 'TUTTI') {
      selected_species = sort(unlist(lapply(1:dim(families)[1], FUN = function(x) {families$nome[x]})))
    }
    else {
      selected_species = selection
    }
    type_choose = input$type_choose
    
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
    
    if(type_choose == 1) {
      df2_choose = df_choose[which(!df_choose$call & df_choose$song ),]
    } else if(type_choose == 2) {
      df2_choose = df_choose[which(df_choose$call & !df_choose$song ),]
    }
    else {
      df2_choose = df_choose
    }
    
    df3_choose <<- merge(df2_choose, families, by.x=c('recordings.gen', 'recordings.sp'), by.y=c('genus', 'specie'))
    output$ready_choose <- renderText('READY!')
  })
  
  observeEvent(input$nxt_choose, {
    i <<- sample(1:dim(df3_choose)[1], 1)
    output$audio_choose <- renderUI({
      tags$audio(src = df3_choose$recordings.file[i], type = "audio/mp3", autoplay = TRUE, controls = TRUE)
    })
  })
  
  observeEvent(input$shw_choose, {
    output$solution_choose <- renderText(paste0('The audio refers to ', df3_choose$nome[i],'. The record type is ', df3_choose$recordings.type[i]))
  })

}

 