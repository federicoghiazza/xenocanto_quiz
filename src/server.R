server <- function(input, output) {
  
  families = read_csv('/Users/fghiazza/Desktop/xenocanto_quiz/data/families.csv')
  df3 = NULL
  df4 = NULL
  i = NULL
  j = NULL
  
  ###### all events of tab 1 - QUIZ
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
      df = rbind(df, dd[1:100,c(6,7,11,16,18)])
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
  
  ###### all events of tab 2 - LEARN
  
  output$FirstChoice <- renderUI ({ 
    selectInput(inputId = "specie_learn",label = "Specie",
                choices = sort(unlist(lapply(1:dim(families)[1], FUN = function(x) {families$nome[x]})))
    )
  })
  
  observeEvent(input$run_learn, {
    selected_specie = input$specie_learn
    type_learn = input$type_learn
    
    show_modal_spinner(
      spin = 'trinity-rings',
      text = 'Please wait...'
    )
    genus=families$genus[which(families$nome == selected_specie)]
    specie=families$specie[which(families$nome == selected_specie)]
    call = GET(paste0("https://www.xeno-canto.org/api/2/recordings?query=", genus, "+", specie))
    df_learn = data.frame(fromJSON(rawToChar(call$content)))
    remove_modal_spinner()
    

    df_learn = df_learn %>% 
      rowwise() %>% 
      mutate(call = grepl('call', recordings.type),
             song = grepl('song', recordings.type)) 
    
    if(type_learn == 1) {
      df2_learn = df_learn[which(!df_learn$call & df_learn$song ),]
    } else if(type_learn == 2) {
      df2_learn = df_learn[which(df_learn$call & !df_learn$song ),]
    }
    else {
      df2_learn = df_learn
    }
    
    df3_learn <<- merge(df2_learn, families, by.x=c('recordings.gen', 'recordings.sp'), by.y=c('genus', 'specie'))
    output$ready_learn <- renderText('READY!')
  })
  
  observeEvent(input$nxt_learn, {
    i <<- sample(1:dim(df3_learn)[1], 1)
    output$audio_learn <- renderUI({
      tags$audio(src = df3_learn$recordings.file[i], type = "audio/mp3", autoplay = TRUE, controls = TRUE)
    })
  })
  
  observeEvent(input$shw_learn, {
    output$solution_learn <- renderText(paste0(df3_learn$recordings.type[i]))
  })
  
  
}
