library(tidyverse)
library(PeriodicTable)
library(tabulizer)

data("periodicTable")

alpha_pages <- seq(103, 203, by = 2)

# z <- tabulizer::extract_tables("nuclear/wapstra-atomic-mass.pdf", 
#                                 pages = alpha_pages)
# saveRDS(z1, "nuclear/wapstra_alpha")
z <- readRDS("nuclear/wapstra_alpha1")

i <- 3
alpha_energy <- function(i) {
  z1 <- z[[i]] |> 
    as_tibble()
  
  z1 <- z1 |> 
    setNames(as.character(z1[1,])) |> 
    janitor::clean_names()
  
  z1 <- z1 |> 
    select(a, elt, z, energy = q_a) |> 
    slice(-1) |> 
    mutate(a = replace(a, a == "", NA)) |> 
    fill(a) |>  
    mutate(energy = str_remove(energy, "#.*"))
  
  z1
}

zq <- map_df(1:51, alpha_energy)


mass_pages <- 17:66
zw <- tabulizer::extract_tables("nuclear/wapstra-atomic-mass.pdf", 
                                     pages = mass_pages)

saveRDS(zw, "nuclear/wapstra_mass")

atomic_mass <- function(i) {
  zw1 <- zw[[i]] |> 
    as_tibble()
  zw1 <- zw1 |> 
    setNames(as.character(zw1[1,])) |> 
    janitor::clean_names()
  zw1 <- zw1 |> 
    select(n, z, a, elt, atomic_mass) |> 
    slice(-1) |> 
    slice(-1) |> 
    mutate(a = replace(a, a == "", NA)) |> 
    fill(a) |>  
    mutate(atomic_mass = str_remove(atomic_mass, "#.*"),
           atomic_mass = str_extract(atomic_mass, "^[0-9]* [0-9]*"),
           atomic_mass = str_replace(atomic_mass, " ", "."),
           atomic_mass = as.numeric(atomic_mass))
  
  zw1
}
atomic_mass_safely <- possibly(atomic_mass)
zwq <- map_df(c(1:18, 20:50), atomic_mass_safely)

alpha <- zq |> 
  left_join(zwq)

families <- alpha |> 
  mutate(a = as.numeric(a)) |> 
  filter(a > 208,
         !is.na(n)) |> 
  mutate(pairing = glue::glue("$^open{a}close{elt}$"),
         pairing = str_replace_all(pairing, "open", "{"),
         pairing = str_replace_all(pairing, "close", "}")) 


semf <- c("$a_{\nu} A$" , "$- a_sA^{-\frac{2}{3}}$", "$- a_cZ(Z-1)A^{-\frac{1}{3}}$", "$- a_{sym}\frac{(A-2Z)^2}{A}$", "$+ \pm a_p A^{-\frac{3}{4}}$")
  
#  $\delta = \pm a_p A^{-\frac{3}{4}}$ "+" for Z/N even/even "-" for Z/N odd/odd else 0


cat(paste0('"', paste(families$elt[1:300], collapse="\", \""), '"'))
(paste0('"', paste(families$a[1:300], collapse="\", \""), '"')) |> 
  str_remove_all("\"")
cat(paste0('"', paste(z$heavy_symbol_2, collapse="\", \""), '"'))
(paste0('"', paste(z$heavy_mass, collapse="\", \""), '"')) |> 
  str_remove_all("\"")