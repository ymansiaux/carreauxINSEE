% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pg02072019.R
\name{calculAgregatsZones}
\alias{calculAgregatsZones}
\title{Fonction calculant les agrégats sur une zone à partir des carreaux qui la recouvrent}
\usage{
calculAgregatsZones(
  cheminFichierContoursSHP,
  cheminFichierCSV,
  listeCodesCommune,
  listeIndic = listeIndicDef
)
}
\arguments{
\item{cheminFichierContoursSHP}{Chemin des contours de la ou des zones}

\item{cheminFichierCSV}{Chemin du fichier csv des données carroyées à 200m}

\item{listeCodesCommune}{Liste des codes Insee des communes}

\item{listeVar}{Liste des agrégats souhaités}
}
\value{
Une table contenant une ligne pour chaque zone du fichier de contours
}
\description{
Fonction calculant les agrégats sur une zone à partir des carreaux qui la recouvrent
}
\examples{
\dontrun{
calculAgregatsZones("c:/mesdocs/moncontour.shp",
                    "c:/mesdocs/Filosofi2015_carreaux_200m_metropole.csv",
                    c("01001","01002"),
                    c("Ind_40_54","Ind_55_64"))
                    }
}
