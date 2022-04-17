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
                                   c("Cince codalunga" = "cince2",
                                     "Piccoli tordi" = "thrushesSmall",
                                     "Grandi tordi" = "thrushesBig",
                                     "Silvidi" = "silvidi",
                                     "Luì" = "Luì",
                                     "Silvidi da mosca" = "silvidiMosche",
                                     "Picchi 2" = "creepers",
                                     "Averle" = "shrikes",
                                     "Storni" = "starlings",
                                     "Passeri" = "sparrows",
                                     "Fringuelli 1" = "finches",
                                     "Zigoli" = "buntings",
                                     "Altri" = "accentors",
                                     "Pispole e ballerine" = "pipits",
                                     "Rapaci notturni" = "rapaci_notturni",
                                     "Pianura novarese in inverno" = "pianura_novarese_inverno",
                                     "Nel canneto in primavera" = "nel_canneto_in_primavera",
                                     "Sicilia sudorientale a Maggio"  = "modica_maggio"
                                   )),
                       selectInput("type", label = h3("Sound type"),
                                   c("Any" = 1,
                                     "Song" = 2,
                                     "Call" = 3)),
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
                                   c("Any" = 1,
                                     "Song" = 2,
                                     "Call" = 3)),
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
