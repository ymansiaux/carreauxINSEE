# Sources :
#
# https://www.insee.fr/fr/statistiques/4176290?sommaire=4176305
#
# https://www.insee.fr/fr/statistiques/4176290?sommaire=4176305#

# Script de conservation des données carroyées présentes dans BM

library(leaflet)
library(sf)
library(data.table)

devtools::load_all()

shp_carreaux_location <- "/data/donnees_geo/donnees_carroyees_insee/carreaux_shp/"
csv_carreaux_location <- "/data/donnees_geo/donnees_carroyees_insee/carreaux_csv/"
iris_bm_location <- "/data/donnees_geo/IRISBM/"


## Methode 1 : En utilisant la méthodo du fichier R insee ----

cheminFichierCSV <- paste0(csv_carreaux_location, "200m/Filosofi2015_carreaux_200m_csv/Filosofi2015_carreaux_200m_metropole.csv")
listeCodesCommune  <- c(33003,33004,33013,33032,33039,33056,33063,33065,33069,33075,33096,33119,33162,33167,33192,
                        33200,33249,33273,33281,33312,33318,33376,33434,33449,33487,33519,33522,33550)
csv_200m <- fread("/data/donnees_geo/donnees_carroyees_insee/carreaux_csv/200m/Filosofi2015_carreaux_200m_csv/Filosofi2015_carreaux_200m_metropole.csv")

# en reprenant le code du site INSEE (modification du script pg02072019.R pour l'adapter en calculCarreaux.R)
carreaux_200m_bm_insee <- calculCarreaux(cheminFichierCSV, listeCodesCommune)

carreaux_1km_bm_insee <- merge(carreaux_200m_bm_insee, csv_200m[, c("IdINSPIRE", "Id_carr1km")]) %>%
  group_by(Id_carr1km) %>%
  summarise(geometry = st_union(geometry))

# carreaux_200m_bm_insee %>%
#   st_transform(crs = 4326) %>%
#   leaflet() %>%
#   addTiles() %>%
#   addPolygons()
#
# carreaux_1km_bm_insee %>%
#   st_transform(crs = 4326) %>%
#   leaflet() %>%
#   addTiles() %>%
#   addPolygons()



## Methode 2 :  en faisant une intersection entre le shp des iris et le shp des carreaux ----
iris_bm <- st_read("/data/donnees_geo/IRISBM/")
test_readshp_1km <- st_read("/data/donnees_geo/donnees_carroyees_insee/carreaux_shp/1000m/Filosofi2015_carreaux_1000m_shp/")
test_readshp_200m <- st_read("/data/donnees_geo/donnees_carroyees_insee/carreaux_shp/200m/Filosofi2015_carreaux_200m_shp/")

carreaux_1km_bm <- test_readshp_1km %>%
  st_intersection(st_union(iris_bm)) # on fait une union de iris_bm pour eviter d'avoir des carreaux à cheval sur plusieurs IRIS

carreaux_200m_bm <- test_readshp_200m %>%
  st_intersection(st_union(iris_bm))

# carreaux_1km_bm %>%
#   st_transform(crs = 4326) %>%
#   leaflet() %>%
#   addTiles() %>%
#   addPolygons()
#
# carreaux_200m_bm %>%
#   st_transform(crs = 4326) %>%
#   leaflet() %>%
#   addTiles() %>%
#   addPolygons()

usethis::use_data(carreaux_200m_bm_insee, overwrite = TRUE)
usethis::use_data(carreaux_1km_bm_insee, overwrite = TRUE)

usethis::use_data(carreaux_1km_bm, overwrite = TRUE)
usethis::use_data(carreaux_200m_bm, overwrite = TRUE)
