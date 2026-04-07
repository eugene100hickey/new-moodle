library(tidyverse)
library(tabulizer)
library(constants)

hbar <- codata$value[codata$symbol == "hbar"]
e <- codata$value[codata$symbol == "e"]
my_file <- here::here("lectures", "physics-nuclear", "background", "gamma-rays.csv")

z <- read_csv(my_file, skip = 1)
names(z) <- "top"
top <- z$top |>
  str_replace_all("B-", "Bminus") |>
  str_replace_all(" -", "-") |>
  str_replace_all("- +(\\d)", "-\\1") |>
  str_remove_all("<") |>
  str_remove_all("\\?") |>
  str_remove_all("~") |>
  str_remove_all("\\*") |>
  str_remove_all(">")

nucleus <- top |>
  str_extract("^[^\\s]*")

energy <- top |>
  str_extract("\\s([^\\s]+)") |>
  str_trim() |>
  as.numeric()

zq <- top |> str_split("\\s+")
nth_element <- function(i, n=5) zq[[i]][n]

lifetime <- map(1:7387, function(i) nth_element(i, n=5)) |>
  unlist() |>
  as.numeric()
lifetime_unit <- map(1:7387, function(i) nth_element(i, n=6)) |>
  unlist()

gammas <- tibble(nucleus, energy, lifetime, lifetime_unit) |>
  filter(lifetime_unit != "N/A") |>
  mutate(life_mult = case_when(
    lifetime_unit == "D" ~ 3600*24,
    lifetime_unit == "H" ~ 3600,
    lifetime_unit == "M" ~ 60,
    lifetime_unit == "MS" ~ 0.001,
    lifetime_unit == "NS" ~ 1e-9,
    lifetime_unit == "US" ~ 1e-6,
    lifetime_unit == "Y" ~ 365.25 * 24 * 3600,
    .default = 1
  )) |>
  mutate(life_sec = lifetime * life_mult) |>
  mutate(Z = nucleus |> str_extract("^[^-]*"),
         A = nucleus |> str_extract("[^-]*$"),
         Z = as.numeric(Z),
         A = as.numeric(A),
         symbol = nucleus |> str_extract("[a-zA-Z]+")) |>
  arrange(Z, A) |>
  mutate(latex = glue::glue("$^open{A}close_open{Z}close{symbol}$"),
         latex = str_replace_all(latex, "open", "{"),
         latex = str_replace_all(latex, "close", "}"),
         natural_lw = hbar / life_sec / e * 1e6)
z1 <- gammas |>
  filter(lifetime_unit == "NS") |>
  select(latex, energy, life_sec, natural_lw) |>
  mutate(life_sec = life_sec * 1e9) |>
  distinct()

cat(paste0('"', paste(z1$energy, collapse="\", \""), '"'))
