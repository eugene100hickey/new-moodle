library(tidyverse)
library(tabulizer)

my_file <- "nuclear/gamma-rays.csv"

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
  arrange(Z, A)

