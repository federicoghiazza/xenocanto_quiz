ui = function() {
  return (
    fluidPage(
      
      setBackgroundImage(
        src = "http://pngimg.com/uploads/birds/birds_PNG71.png"
      ),
      
      fluidRow(
        tabsetPanel( id = 'ciao',
          tabPanel("Guess the bird", 
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
          
          tabPanel("Learn 1 bird",
                   sidebarLayout(
                     sidebarPanel(
                       uiOutput("FirstChoice"),
                       selectInput("type_learn", label = h3("Sound type"),
                                   c("Song" = 1,
                                     "Call" = 2,
                                     "Any" = 3)),
                       actionButton("run_learn", "Download")
                     ),
                     
                     mainPanel(
                       span(textOutput("ready_learn"), style="color:red; font-size: 30px"),
                       span(textOutput("solution_learn"), style="color:blue; font-size: 20px")
                     )
                   ),
                   
                   mainPanel(
                     uiOutput("audio_learn"),
                     actionButton("nxt_learn", "Next"),
                     actionButton('shw_learn', 'Show')                   )
                   )
        )
      )
      
    )
  )
}
