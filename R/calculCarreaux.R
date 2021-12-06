calculCarreaux <- function(cheminFichierCSV, listeCodesCommune) {

  listeIndic <- unique(c("IdINSPIRE","Depcom","I_est_cr"))

  # importation de la table des carreaux
  # et filtrage des observations selon le(s) code(s) commune(s)
  carreaux <- data.table::fread(cheminFichierCSV, select = c(listeIndic)) %>%
    dplyr::filter(Depcom %in% listeCodesCommune) %>%
    dplyr::mutate(I_est_cr = as.integer(I_est_cr))

  # liste des identifiants Inspire des carreaux, à partir desquels
  # on récupère leurs coordonnées, leur taille et leur code epsg
  cIdInspire <- as.character(carreaux$IdINSPIRE)

  epsg <- as.integer(str_sub(str_extract(carreaux[1,]$IdINSPIRE, "CRS\\d+"), 4))

  tailleCarreaux <- unlist(lapply(X = cIdInspire, FUN = function(ligne){
    return(as.integer(str_sub(str_extract(ligne, "RES\\d+"), 4)))
  }))
  ordonneesCarreaux <- unlist(lapply(X = cIdInspire, FUN = function(ligne){
    return(as.integer(str_sub(str_extract(ligne, "N\\d+"), 2)))
  }))
  abscissesCarreaux <- unlist(lapply(X = cIdInspire, FUN = function(ligne){
    return(as.integer(str_sub(str_extract(ligne, "E\\d+"), 2)))
  }))

  # ajout de 2 colonnes donnant les coordonnées du coin inférieur gauche du carreau
  carreaux$x <- abscissesCarreaux
  carreaux$y <- ordonneesCarreaux

  # création d'une colonne geometry contenant les coordonnées des contours des carreaux
  # puis transformation en objets geométriques a l'aide du package sf
  carreaux$geometry <- sprintf("POLYGON ((%i %i, %i %i, %i %i, %i %i, %i %i))",
                               carreaux$x, carreaux$y,
                               carreaux$x + tailleCarreaux, carreaux$y,
                               carreaux$x + tailleCarreaux, carreaux$y + tailleCarreaux,
                               carreaux$x, carreaux$y + tailleCarreaux,
                               carreaux$x, carreaux$y)

  carreauxSf <- sf::st_as_sf(carreaux, wkt = "geometry", crs = epsg)
  carreauxSf

}
