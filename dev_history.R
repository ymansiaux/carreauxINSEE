usethis::use_build_ignore(files = "dev_history.R")
usethis::use_build_ignore("renv_setup.R")

usethis::use_gpl3_license()

renv::init()
usethis::use_git_ignore(ignores = "./renv/library", directory = ".")
usethis::use_git_ignore(ignores = "./renv/local", directory = ".")

usethis::use_pipe()

usethis::use_data_raw("fichiers_geo_carreaux_BM")


attachment::att_amend_desc()

#
vignettes <- FALSE
devtools::check()
devtools::build(vignettes = vignettes)
devtools::install(build_vignettes = vignettes)

pkgload::load_all()
