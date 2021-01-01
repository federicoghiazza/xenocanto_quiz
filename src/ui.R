ui = function() {
  return (
    fluidPage(
      
      tags$head(
        tags$style(
          HTML(".shiny-notification {
             position:fixed;
             top: calc(40%);
             left: calc(30%);
             font-size: 30px
             }
             "
          )
        )
      ),
      
      setBackgroundImage(
        src = "http://pngimg.com/uploads/birds/birds_PNG71.png"
      ),
      
      fluidRow(
        tabsetPanel( id = 'ciao',
                     
          ### FIRST PANEL: FAMILY QUIZ
          tabPanel("Grouped quiz", 
                   sidebarLayout(
                     sidebarPanel(
                       textOutput('attenzione'),
                       selectInput("family", label = h3("Bird group"),
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
                                     "Rondini e topino" = "swallows",
                                     "Rapaci notturni" = "rapaci_notturni"
                                   )),
                       selectInput("type", label = h3("Sound type"),
                                   c("Song" = 1,
                                     "Call" = 2,
                                     "Any" = 3)),
                       actionButton("run", "Download")
                     ),
                     
                     mainPanel(
                       tableOutput("table"),
                       span(textOutput("solution"), style="color:blue; font-size: 20px")
                     )
                   ),
                   
                   mainPanel(
                     uiOutput("audio"),
                     actionButton("nxt", "Next"),
                     actionButton('shw', 'Show')
                   )),
          
          ##### SECOND PANEL: SELECTABLE SPECIES
          tabPanel("Choose quiz", 
                   sidebarLayout(
                     sidebarPanel(
                       textOutput('attenzione_choose'),
                       actionButton("select_all", "Select all"),
                       actionButton("deselect_all", "Deselect all"),
                       uiOutput("FirstChoice_choose"),
                       selectInput("type_choose", label = h3("Sound type"),
                                   c("Song" = 1,
                                     "Call" = 2,
                                     "Any" = 3)),
                       actionButton("run_choose", "Download"),
                       width = 11
                     ),
                     
                     mainPanel(
                       span(textOutput("ready_choose"), style="color:red; font-size: 30px"),
                       uiOutput("audio_choose"),
                       actionButton("nxt_choose", "Next"),
                       actionButton('shw_choose', 'Show'),
                       span(textOutput("solution_choose"), style="color:black; font-size: 30px")
                     )
                   )
            )
          
        )
        
        
      )
      
    )
  )
}
