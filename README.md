# DashboardRProject

Un Dashboard interactif créé avec RShiny pour analyser les données sur la criminalité à Los Angeles à partir de 2020. 
L'objectif à été de révéler des tendances, des motifs et fournir des aperçus des incidents criminels.

## Aperçu

Le tableau de bord offre une visualisation interactive des données criminelles de Los Angeles, facilitant la compréhension des tendances et des statistiques clés. Les utilisateurs peuvent explorer et filtrer les données en fonction de différents critères, permettant une analyse approfondie.

![image](https://github.com/benguir/dashboardProjectR/assets/97590761/a9fb73ce-9ffd-4743-bf6a-f7740f88e78e)

## Fonctionnalités

- Sélection interactive des districts et des catégories de crimes.
- Affichage des nombres de crimes, des ratios et des totaux.
- Carte interactive avec localisation des incidents criminels.
- Graphique de ratio de crimes par district.
- Filtres par sexe, âge et plage de dates.
- Aperçu des données via le bouton ON / OFF

## Prérequis

Assurez-vous d'avoir les éléments suivants installés avant de lancer le tableau de bord 

R Version 3.6.0 ou supérieur ou [Download R 4.3.2](https://cran.r-project.org/bin/windows/base/)

[Donwload R Studio](https://posit.co/download/rstudio-desktop/)

Sur la console R Studio executez le code
```R
install.packages(c("shiny", "tidyverse", "leaflet", "leaflet.extras", "shinyWidgets", "plotly", "shinythemes", "shinydashboard", "ggplot2", "DT"))
```

## Installation

1. [Clonez ce dépôt](https://github.com/benguir/dashboardProjectR.git) sur votre machine locale.

2. Ouvrir app.R avec R Studio puis Run App


