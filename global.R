# Chargement des données depuis le fichier CSV
print("data charged")
data <- read.csv("DATA/crimeData.csv", header = TRUE)
print("data load")

# Définition du titre de l'application Shiny
titre_appli = " analyse crime 2023"

# Extraction des noms des variables de la base de données
variables_data = names(data)

# Transformation des données : conversion de la colonne DATE.OCC en format Date et regroupement des catégories de crimes
data <- data %>%
  mutate(
    DATE.OCC = as.Date(DATE.OCC, format = "%m/%d/%Y %I:%M:%S %p"),
    `Crm.Cd.Desc` = case_when(
      `Crm.Cd.Desc` %in% c("BATTERY - SIMPLE ASSAULT", "INTIMATE PARTNER - SIMPLE ASSAULT", "ASSAULT WITH DEADLY WEAPON, AGGRAVATED ASSAULT", "CRIMINAL THREATS - NO WEAPON DISPLAYED", "BATTERY WITH SEXUAL CONTACT") ~ "Agression et menaces",
      `Crm.Cd.Desc` %in% c("SHOPLIFTING - PETTY THEFT ($950 & UNDER)", "THEFT-GRAND ($950.01 & OVER) EXCPT, GUNS, FOWL, LIVESTK, PROD", "ROBBERY", "BURGLARY", "VEHICLE - STOLEN") ~ "Vol et cambriolage",
      `Crm.Cd.Desc` %in% c("VANDALISM - MISDEMEANOR ($399 OR UNDER)", "VANDALISM - FELONY ($400 & OVER, ALL CHURCH VANDALISMS)", "BURGLARY FROM VEHICLE", "ARSON", "THEFT PLAIN - PETTY ($950 & UNDER)") ~ "Infractions contre les biens",
      `Crm.Cd.Desc` %in% c("RAPE, FORCIBLE", "SEX OFFENDER REGISTRANT OUT OF COMPLIANCE", "LEWD/LASCIVIOUS ACTS WITH CHILD", "ORAL COPULATION", "SEXUAL PENETRATION W/FOREIGN OBJECT") ~ "Infractions sexuelles",
      `Crm.Cd.Desc` %in% c("KIDNAPPING", "KIDNAPPING - GRAND ATTEMPT", "CHILD STEALING", "CHILD ABANDONMENT", "FALSE IMPRISONMENT") ~ "Enlèvement et séquestration",
      `Crm.Cd.Desc` %in% c("BRANDISH WEAPON", "DISCHARGE FIREARMS/SHOTS FIRED", "WEAPONS POSSESSION/BOMBING", "FIREARMS EMERGENCY PROTECTIVE ORDER (FIREARMS EPO)", "DRIVING WITHOUT OWNER CONSENT (DWOC)") ~ "Armes et armes à feu",
      `Crm.Cd.Desc` %in% c("DISTURBING THE PEACE", "VIOLATION OF COURT ORDER", "TRESPASSING", "FAILURE TO YIELD", "RECKLESS DRIVING") ~ "Infractions à l'ordre public",
      `Crm.Cd.Desc` %in% c("CHILD ABUSE (PHYSICAL) - SIMPLE ASSAULT", "CHILD ABUSE (PHYSICAL) - AGGRAVATED ASSAULT", "CHILD NEGLECT (SEE 300 W.I.C.)", "CHILD PORNOGRAPHY", "CRUELTY TO ANIMALS") ~ "Crimes contre les enfants",
      `Crm.Cd.Desc` %in% c("OTHER MISCELLANEOUS CRIME", "BOMB SCARE", "EXTORTION", "STALKING", "HUMAN TRAFFICKING - COMMERCIAL SEX ACTS") ~ "Crimes divers",
      `Crm.Cd.Desc` %in% c("ATTEMPTED ROBBERY", "THEFT PLAIN - ATTEMPT", "SHOPLIFTING - ATTEMPT", "BUNCO, ATTEMPT", "CONSPIRACY") ~ "Tentatives et complots"
    )
  )
