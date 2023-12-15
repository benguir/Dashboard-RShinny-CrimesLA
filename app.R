source("Packages.R")
source("global.r")

ui <- fluidPage(
  titlePanel("Crime LA"),
  
  fluidRow(
    column(4,
      selectInput("select", h5("Crime"), 
                choices = list("Viol" = 1, "Meurtre" = 2,
                               "Cambriolage" = 3), selected = 1),
      selectInput("select", h5("Ville"), 
                choices = list("Hollywood" = 1, "Harbor" = 2,
                               "Central" = 3), selected = 1)),
    column(8,
      p("Ville"))
  )
)

server <- function(input, output){}

shinyApp(ui = ui, server = server)
