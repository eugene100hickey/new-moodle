library(tidyverse)
#library(tabulizer)
library(constants)

hbar <- codata$value[codata$symbol == "hbar"]
e <- codata$value[codata$symbol == "e"]
u <- codata$value[codata$symbol == "u"]
c0 <- codata$value[codata$symbol == "c0"]
my_file <- here::here("lectures", "physics-nuclear", "background", "gamma-rays1.csv")
gammas <- read_csv(my_file)
# z <- read_csv(my_file, skip = 1)
# names(z) <- "top"
# top <- z$top |>
#   str_replace_all("B-", "Bminus") |>
#   str_replace_all(" -", "-") |>
#   str_replace_all("- +(\\d)", "-\\1") |>
#   str_remove_all("<") |>
#   str_remove_all("\\?") |>
#   str_remove_all("~") |>
#   str_remove_all("\\*") |>
#   str_remove_all(">")
#
# nucleus <- top |>
#   str_extract("^[^\\s]*")
#
# energy <- top |>
#   str_extract("\\s([^\\s]+)") |>
#   str_trim() |>
#   as.numeric()
#
# zq <- top |> str_split("\\s+")
# nth_element <- function(i, n=5) zq[[i]][n]
#
# lifetime <- map(1:7387, function(i) nth_element(i, n=5)) |>
#   unlist() |>
#   as.numeric()
# lifetime_unit <- map(1:7387, function(i) nth_element(i, n=6)) |>
#   unlist()
#
# gammas <- tibble(nucleus, energy, lifetime, lifetime_unit) |>
#   filter(lifetime_unit != "N/A") |>
#   mutate(life_mult = case_when(
#     lifetime_unit == "D" ~ 3600*24,
#     lifetime_unit == "H" ~ 3600,
#     lifetime_unit == "M" ~ 60,
#     lifetime_unit == "MS" ~ 0.001,
#     lifetime_unit == "NS" ~ 1e-9,
#     lifetime_unit == "US" ~ 1e-6,
#     lifetime_unit == "Y" ~ 365.25 * 24 * 3600,
#     .default = 1
#   )) |>
#   mutate(life_sec = lifetime * life_mult) |>
#   mutate(Z = nucleus |> str_extract("^[^-]*"),
#          A = nucleus |> str_extract("[^-]*$"),
#          Z = as.numeric(Z),
#          A = as.numeric(A),
#          symbol = nucleus |> str_extract("[a-zA-Z]+"),
#          latex = glue::glue("$^open{A}close_open{Z}close{symbol}$"),
#          latex = str_replace_all(latex, "open", "{"),
#          latex = str_replace_all(latex, "close", "}"),
#          natural_lw = (hbar / life_sec / e * 1e9) |> signif(4),
#          combo = glue::glue("{A}{symbol}")) |>
#   arrange(Z, A)

my_file <- my_file <- here::here("lectures", "physics-nuclear", "background", "nuclear-data.csv")
my_masses <- read_csv(my_file) |>
  select(z, n, symbol, radius, atomic_mass) |>
  mutate(a = n+z) |>
  mutate(combo = glue::glue("{a}{symbol}"),
         atomic_mass = atomic_mass / 1e6) |>
  select(combo, atomic_mass) |>
  drop_na()


gammas <- gammas |>
  left_join(my_masses) |>
  mutate(recoil = ((energy*1e3*e)^2 / (2*atomic_mass*u*c0^2) / e) |> signif(4))

z1 <- gammas |>
  filter(lifetime_unit == "NS") |>
  select(latex, life_sec, energy, natural_lw) |>
  distinct() |>
  mutate(life_ns = life_sec * 1e9)


cat(paste0('"', paste(z1$latex, collapse="\", \""), '"'))
(paste0('"', paste(z1$natural_lw, collapse="\", \""), '"')) |>
  str_remove_all("\"")
