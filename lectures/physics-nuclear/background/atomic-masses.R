# https://www-nds.iaea.org/relnsd/vcharthtml/api_v0_guide.html
library(tidyverse)
library(tabulizer)
library(PeriodicTable)

my_file <- here::here("lectures", "physics-nuclear", "background", "all-alphas-wiley.pdf")
z <- tabulizer::extract_tables(my_file, pages = 1:8)
elements1 <- map(1:8, function(x) z[[x]] |> as_tibble() |> pull(V3)) |> unlist()
elements <- trimws(elements1, whitespace = "\\s*\\(.*") |>
  str_remove_all("Parent")
elements <- elements[elements != ""]
elements2 <- str_extract(elements1, "(?<=\\().+?(?=\\))")
elements2 <- elements2[!is.na(elements2)]
life_unit <- elements2 |> str_extract("[a-z]+")
life_value <- elements2 |> str_remove("[a-zA-Z]+")
life_comp <- word(life_value, 1, sep = "x") |> str_trim()
life_comp <- str_split(life_value, pattern = "×10", simplify = T)[,1] |>
  str_trim()
life_exp <- str_split(life_value, pattern = "×10", simplify = T)[,2] |>
  str_trim()

element_no <- elements |> str_remove("[a-zA-Z]+")
element_symbol <- elements |> str_remove("[0-9]+")
my_elements <- tibble(element = elements,
                      nom = element_no,
                      symbol = element_symbol,
                      lifetime = elements2,
                      units = life_unit,
                      life_value = life_value,
                      life_comp = life_comp |> as.numeric(),
                      life_exp = life_exp |> as.numeric()) |>
  unique() |>
  mutate(life_exp = replace_na(life_exp, 0),
         lifetime_sec = life_comp * 10^life_exp,
         lifetime_sec = case_when(
           units == "d" ~ lifetime_sec * 24*3600,
           units == "h" ~ lifetime_sec * 3600,
           units == "m" ~ lifetime_sec * 60,
           units == "ms" ~ lifetime_sec * 0.001,
           units == "us" ~ lifetime_sec * 1e-6,
           units == "y" ~ lifetime_sec * 365*24*3600,
           .default = lifetime_sec
         ),
         activity = log(2) / lifetime_sec, .after = lifetime)


my_elements |>
  ggplot(aes(lifetime_sec)) +
  geom_density() +
  scale_x_log10()


# base_url <- "https://nds.iaea.org/relnsd/v1/data?"
# query <- "fields=decay_rads&nuclides=233U&rad_types=a"
# url <- glue::glue("{base_url}{query}")
#
# z2 <- read_csv(url)
my_file <- my_file <- here::here("lectures", "physics-nuclear", "background", "nuclear-data.csv")
z1 <- read_csv(my_file) |>
  select(z, n, symbol, radius, atomic_mass) |>
  mutate(a = n+z) |>
  mutate(combo = glue::glue("{a}{symbol}"))

z <- z1|>
  filter(combo %in% my_elements$element) |>
  mutate(d_a = a-4,
         d_z = z-2,
         d_symbol = PeriodicTable::symb(d_z),
         d_combo = glue::glue("{d_a}{d_symbol}")) |>
  left_join(z1 |> select(d_atomic_mass = atomic_mass, d_combo = combo)) |>
  mutate(atomic_mass = atomic_mass / 1e6,
         d_atomic_mass = d_atomic_mass / 1e6,
         mev = (atomic_mass - d_atomic_mass -  4.002603) * 931.75, .after = symbol) |>
  select(-radius) |>
  unique()
names(z)


cat(paste0('"', paste(my_elements$symbol, collapse="\", \""), '"'))
cat(paste0('"', paste(z$d_symbol, collapse="\", \""), '"'))
(paste0('"', paste(my_elements$nom, collapse="\", \""), '"')) |>
  str_remove_all("\"")
(paste0('"', paste(z$d_a, collapse="\", \""), '"')) |>
  str_remove_all("\"")
(paste0('"', paste(z$atomic_mass |> round(5), collapse="\", \""), '"')) |>
  str_remove_all("\"")
(paste0('"', paste(z$d_atomic_mass |> round(5), collapse="\", \""), '"')) |>
  str_remove_all("\"")
(zq <- (paste0('"', paste(my_elements$lifetime_sec |> round(3), collapse="\", \""), '"')) |>
  str_remove_all("\"") |>
  str_replace_all("e\\+([0-9]+)", "\\\\\\\\times10^{\\1}") |>
  str_replace_all(", ", '$\\", \\"$'))
cat(zq)

options(scipen = 999)
(paste0('"', paste(my_elements$lifetime_sec, collapse="\", \""), '"')) |>
  str_remove_all("\"")
options(scipen = 0)
cat(paste0('"', paste(my_elements$symbol, collapse="\", \""), '"'))
(paste0('"', paste(my_elements$nom, collapse="\", \""), '"')) |>
  str_remove_all("\"")


# Sun Mar 23 12:50:27 2025 ------------------------------

### Hydrogen questions ###
data("periodicTable")
my_elements <- periodicTable |>
  select(symbol = symb, nom = name, numb)

cat(paste0('"', paste(my_elements$nom, collapse="\", \""), '"'))
cat(paste0('"', paste(z$d_symbol, collapse="\", \""), '"'))
(paste0('"', paste(my_elements$numb, collapse="\", \""), '"')) |>
  str_remove_all("\"")
(paste0('"', paste(z$d_a, collapse="\", \""), '"')) |>
  str_remove_all("\"")
(paste0('"', paste(z$atomic_mass |> round(5), collapse="\", \""), '"')) |>
  str_remove_all("\"")
(paste0('"', paste(z$d_atomic_mass |> round(5), collapse="\", \""), '"')) |>
  str_remove_all("\"")
(zq <- (paste0('"', paste(my_elements$lifetime_sec |> round(3), collapse="\", \""), '"')) |>
    str_remove_all("\"") |>
    str_replace_all("e\\+([0-9]+)", "\\\\\\\\times10^{\\1}") |>
    str_replace_all(", ", '$\\", \\"$'))
cat(zq)
