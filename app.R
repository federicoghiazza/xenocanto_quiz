#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readr)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Guess the bird"),
    
    sidebarLayout(
        sidebarPanel(
            selectInput("family", label = h3("Family"),
                        c("Picchi" = "picchi",
                          "Cince" = "cince",
                          "Cince codalunga" = "cince2",
                          "Piccoli tordi" = "thrushesSmall",
                          "Grandi tordi" = "thrushesBig",
                          "Silvidi" = "silvidi",
                          "Silvidi da canneto" = "silvidiCanneto",
                          "Luì" = "Luì",
                          "Silvidi da mosca" = "silvidiMosche",
                          "Allodole" = "larks",
                          "Picchi 2" = "creepers",
                          "Averle" = "shrikes",
                          "Corvi 1" = "crowsSmall",
                          "Corvi 2" = "crowsBig",
                          "Storni" = "starlings",
                          "Passeri" = "sparrows",
                          "Fringuelli 1" = "finches1",
                          "Fringuelli 2" = "finches2",
                          "Zigoli" = "buntings",
                          "Altri" = "accentors",
                          "Pispole e ballerine" = "pipits",
                          "Rondini e topino" = "swallows"
                          )),
            selectInput("type", label = h3("Sound type"),
                        c("Song" = 1,
                          "Call" = 2,
                          "Any" = 3)),
            actionButton("run", "Download")
        ),
        
        mainPanel(
            tableOutput("table")
        )
    ),
    
    mainPanel(
        uiOutput("audio"),
        actionButton("nxt", "Next"),
        actionButton('shw', 'Show'),
        textOutput("solution")
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    
    families = read_csv('/Users/fghiazza/Desktop/xeno_canto/data/families.csv')
    df3 = NULL
    i = NULL
    
    observeEvent(input$run, {
        selected_family = input$family
        type = input$type
        
        df = NULL
        for (i in which(families$family == selected_family)) {
            genus=families$genus[i]
            specie=families$specie[i]
            call = GET(paste0("https://www.xeno-canto.org/api/2/recordings?query=", genus, "+", specie))
            dd = data.frame(fromJSON(rawToChar(call$content)))
            df = rbind(df, dd[1:100,c(6,7,11,16,18)])
        }
        
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

}

# Run the application 
shinyApp(ui = ui, server = server)
