# https://exoplanetarchive.ipac.caltech.edu/cgi-bin/TblView/nph-tblView?app=ExoTbls&config=PS

library(tidyverse)
library(scales)
'https://exoplanetarchive.ipac.caltech.edu/cgi-bin/nstedAPI/nph-nstedAPI?table=exoplanets&format=ascii'
my_file <- "physics-school/img/exoplanets/data/PS_2026.10.30_09.22.45.csv"
my_file <- "physics-school/img/exoplanets/data/solar_system_and_dwarf_planets.csv"
my_url <- "https://exoplanetarchive.ipac.caltech.edu/TAP/sync?query=
select+pl_name,disc_year,pl_bmasse,pl_rade,pl_orbsmax,discoverymethod
from+PSCompPars
&format=csv"
z <- read_csv(my_file)
z1 <- read_csv(my_url)
z <- read_csv(my_file,
              skip = 18) |>
  select(pl_name,disc_year,pl_masse,pl_rade,pl_orbsmax,pl_orbper, discoverymethod) |>
  drop_na() |>
  mutate(pl_orbper = pl_orbper / 365.25)
z_cols <- read_csv(my_file, n_max = 94)

z |>
  filter(pl_orbper < 1e2) |>
  ggplot(aes(pl_orbper, pl_masse, colour = discoverymethod)) +
  geom_point(show.legend = F, alpha = 0.1) +
  scale_x_log10(labels = scales::label_number(scale_cut = cut_si("year"))) +
  scale_y_log10(labels = scales::label_number(scale_cut = cut_si("mass_earth")))
