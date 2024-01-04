# Chargement des packages et du fichier global.R
source("Packages.R")
source("global.r")

# Définition de l'interface utilisateur (UI)
ui <- fluidPage(
  titlePanel(
    h1("Crimes LA"),
  ),
  div(
    style = "background-color: #cccbc8; height: 5px; margin-top:-10px; margin-bottom: 20px; width: 100%; box-shadow: 0px 0px 1px 0px #888888;"
  ),
  fluidRow(
    # Colonne pour les sélections de ville et de catégorie de crime
    column(3,
           pickerInput("city_select", h5("District"), 
                       choices = unique(data$`AREA.NAME`),
                       options = list('actions-box' = TRUE),
                       multiple = TRUE,
                       selected = unique(data$`AREA.NAME`)[1:4]),
           pickerInput("crime_select", h5("Catégories de crimes"),
                       choices = c("Agression et menaces" = "Agression et menaces", 
                                   "Vol et cambriolage" = "Vol et cambriolage",
                                   "Infractions contre les biens" = "Infractions contre les biens",
                                   "Infractions sexuelles" = "Infractions sexuelles",  # Ajout de la nouvelle catégorie
                                   "Enlèvement et séquestration" = "Enlèvement et séquestration", 
                                   "Armes et armes à feu" = "Armes et armes à feu",
                                   "Infractions à l'ordre public" = "Infractions à l'ordre public",
                                   "Crimes contre les enfants" = "Crimes contre les enfants",
                                   "Crimes divers" = "Crimes divers",
                                   "Tentatives et complots" = "Tentatives et complots"),
                       options = list('actions-box' = TRUE),
                       multiple = TRUE,
                       selected = c("Agression et menaces", "Infractions à l'ordre public", "Infractions sexuelles"))
    ),
    # Colonne pour afficher les résultats de sélection
    column(3,
           br(),
           div(
             style = "text-align: center; display: flex; flex-direction: column; align-items: center;",
             div(
               style = "background-color: #cccbc8; width: 250px; height: 30px; margin: 0 auto; border: 1px solid #000;",
               h4(style = "font-size: 16px; color: black; margin: 0; line-height: 30px;", "Nombres de crimes")
             ),
             div(
               style = "background-color: #d4eaf7; width: 250px; height: 70px; margin: 0 auto; border: 1px solid #000;",
               p(style = "font-size: 24px; color: #333; margin: 15px 0 0 0;", textOutput("result_selected_crimes"))
             )
           )
    ),
    # Colonne pour afficher le ratio des crimes
    column(3,
           br(),
           div(
             style = "text-align: center; display: flex; flex-direction: column; align-items: center;",
             div(
               style = "background-color: #cccbc8; width: 250px; height: 30px; margin: 0 auto; border: 1px solid #000;",
               h4(style = "font-size: 16px; color: black; margin: 0; line-height: 30px;", "Ratio des crimes")
             ),
             div(
               style = "background-color: #d4eaf7; width: 250px; height: 70px; margin: 0 auto; border: 1px solid #000;",
               p(style = "font-size: 24px; color: black; margin: 15px 0 0 0;", textOutput("result_crime_ratio"))
             )
           )
    ),
    # Colonne pour afficher le nombre total de crimes
    column(3,
           br(),
           div(
             style = "text-align: center; display: flex; flex-direction: column; align-items: center;",
             div(
               style = "background-color: #cccbc8; width: 250px; height: 30px; margin: 0 auto; border: 1px solid #000;",
               h4(style = "font-size: 16px; color: black; margin: 0; line-height: 30px;", "Nombre total de crimes")
             ),
             div(
               style = "background-color:#d4eaf7; width: 250px; height: 70px; margin: 0 auto; border: 1px solid #000;",
               p(style = "font-size: 24px; color: #333; margin: 15px 0 0 0;", textOutput("result_total_crimes"))
             )
           )
    )
  ),
  br(),
  fluidRow(
    # Colonne pour afficher le graphique du ratio des crimes
    column(3,
           tags$style(HTML("
      #crime_ratio_plot {
        margin-top: -25px;
      }
    ")),
           plotlyOutput("crime_ratio_plot")
    ),
    # Colonne pour afficher la carte
    column(9,
           tags$style(HTML("
      #map {
        border: 1px solid #000;
        margin-top: -50px;
        padding: 10px;
      }
    ")),
           leafletOutput("map")  
    )
  ),
  br(),
  fluidRow(
    # Colonne pour les filtres supplémentaires
    column(3,
           checkboxGroupButtons(
             inputId = "gender_select",
             label = h5("Sexe"),
             choices = c("Homme" = "M", "Femme" = "F", "Autres" = "X"),
             selected = "M",
             checkIcon = list(
               yes = tags$i(class = "fa fa-check-square", style = "color: steelblue"),
               no = tags$i(class = "fa fa-square-o", style = "color: steelblue")
             )
           )
    ),
    column(3,
           sliderInput("age_select", h5("Âge"),
                       min = 1,
                       max = 100,
                       value = c(1, 100),
                       step = 1)
    ),
    column(4,
           dateRangeInput("date_range", h5("Plage de dates"),
                          start = "2020-01-01",
                          end = max(data$DATE.OCC),
                          separator = " - ")
    ),
    column(2,
           br(),
           p("Apercu des données"),
           switchInput("toggle_map", "", onStatus = "success", offStatus = "danger", value = FALSE)
    ),
    # Ligne de séparation
    div(
      style = "background-color: #cccbc8; height: 5px; margin-top:-10px; margin-bottom: 20px; width: 100%; box-shadow: 0px 0px 1px 0px #888888;"
    )
  ),
  DTOutput("datatable_output")
)

# Définition de la fonction serveur
server <- function(input, output, session) {
  # Initialisation des valeurs réactives
  map_visible <- reactiveVal(TRUE)
  filtered_data <- reactiveVal(NULL)
  
  # Observer pour réagir aux changements dans les sélections de l'utilisateur
  observe({
    # Vérification des sélections
    if (is.null(input$city_select) || is.null(input$crime_select)) {
      return(NULL)
    }
    
    # Traitement des données
    data <- data %>%
      mutate(DATE.OCC = as.Date(DATE.OCC, format = "%m/%d/%Y %I:%M:%S %p"))
    
    temp_filtered_data <- data %>%
      filter(`AREA.NAME` %in% input$city_select,
             `Crm.Cd.Desc` %in% input$crime_select,
             `Vict.Sex` %in% input$gender_select,
             `Vict.Age` >= input$age_select[1] & `Vict.Age` <= input$age_select[2],
             DATE.OCC >= input$date_range[1] & DATE.OCC <= input$date_range[2])
    
    temp_filtered_data <- temp_filtered_data %>%
      filter(LAT >= 24.396308 & LAT <= 49.384358 & LON >= -125.000000 & LON <= -66.934570)
    
    # Calcul des ratios de crimes par district
    city_crime_ratios <- temp_filtered_data %>%
      group_by(`AREA.NAME`) %>%
      summarise(crime_ratio = n() / nrow(temp_filtered_data))
    
    # Calcul du ratio global de crimes
    global_crime_ratio <- nrow(temp_filtered_data) / nrow(data)
    
    # Affichage des résultats dans l'interface
    output$result_selected_crimes <- renderText({
      paste(nrow(temp_filtered_data))
    })
    
    output$result_crime_ratio <- renderText({
      paste(sprintf("%.2f%%", global_crime_ratio * 100))
    })
    
    output$result_total_crimes <- renderText({
      paste(nrow(data))
    })
    
    # Création du graphique du ratio des crimes
    gg <- ggplot(city_crime_ratios, aes(x = crime_ratio, y = `AREA.NAME`)) +
      geom_bar(stat = "identity", position = "identity", fill = "#d4eaf7") +
      geom_text(aes(label = sprintf("%.2f%%", crime_ratio * 100)), 
                position = position_stack(vjust = 0.5), hjust = -0.2) +
      labs(title = "", x = "", y = "")
    
    # Conversion du graphique en objet Plotly
    p <- ggplotly(gg)
    
    # Affichage du graphique
    output$crime_ratio_plot <- renderPlotly({
      p
    })
    
    # Mise à jour des données filtrées
    filtered_data(temp_filtered_data)
  })
  
  # Affichage de la carte Leaflet
  output$map <- renderLeaflet({
    req(filtered_data())
    
    # Définition de la palette de couleurs en fonction des catégories de crime
    color_palette <- colorFactor("Set1", levels = unique(filtered_data()$Crm.Cd.Desc))
    
    # Création de la carte avec des marqueurs circulaires
    leaflet() %>%
      addTiles() %>%
      addCircleMarkers(data = filtered_data(), 
                       lat = ~LAT, 
                       lng = ~LON, 
                       color = ~color_palette(Crm.Cd.Desc),
                       radius = 4,
                       fillOpacity = 1,
                       clusterOptions = markerClusterOptions(),
                       label = ~Crm.Cd.Desc)
  })
  
  # Affichage de la table de données
  output$datatable_output <- renderDT({
    if (!input$toggle_map) {
      return(NULL)
    }
    
    datatable(filtered_data(), options = list(pageLength = 10))  
  })
}

# Lancement de l'application Shiny
shinyApp(ui = ui, server = server)
