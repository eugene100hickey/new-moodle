library(tidyverse)
library(PeriodicTable)
library(tabulizer)
library(rvest)
data("periodicTable")

my_url <- "https://www.sisweb.com/referenc/source/exactmas.htm"
my_xml <- "td , th"
z <- read_html(my_url)
z1 <- html_elements(z, my_xml) |> 
  html_text2()

my_elements <- tibble(name = z1[c(T, F, F, F)],
                      a = z1[c(F, T, F, F)],
                      mass = z1[c(F, F, T, F)],
                      abundance = z1[c(F, F, F, T)]) |> 
  filter(name !="Name") |> 
  mutate(mass = as.numeric(mass),
         a = str_extract(a, "[0-9]+")) |> 
  arrange(mass) |> 
  left_join(periodicTable |> select(name, symb, z = numb)) |> 
  mutate(z = as.numeric(z),
         a = as.numeric(a),
         n = a - z) |> 
  relocate(a, .before = z)


beta <- c("36Cl", "48Ca", "50V", "60Fe", "55Br", 
          "87Rb", "93Zr", "94Nb", "96Zr", "97Zr", 
          "98Tc", "99Tc", "101Mo", "113Cd", "115Cd", "115In",
          "117Cd", "119In", "123Sn", "126Sn", "135Cs",
          "137Cs", "125Sb", "141Ce", "159Gd", "161Tb", "169Er",
          "14C", "90Sr", "3H", "60Co")

beta_decays <- tibble(p_symb = beta |> str_extract("[A-Za-z]+"),
                      beta_a = beta |> str_extract("[0-9]+") |> as.numeric()) |> 
  left_join(periodicTable |> select(p_numb = numb, 
                                    p_symb = symb, 
                                    p_name = name)) |> 
  mutate(d_numb = p_numb + 1) |> 
  left_join(periodicTable |> select(d_numb = numb, 
                                    d_symb = symb, 
                                    d_name = name)) |> 
  left_join(my_elements |> select(p_symb = symb, beta_a = a, p_mass = mass))


# Mon Feb  2 12:36:02 2026 ------------------------------

beta_decays <- function(my_z = "118") {
    my_url <- glue::glue("https://periodictable.com/Elements/{my_z}/data.html")
  my_xml <- "tr:nth-child(45) td , tr:nth-child(45) a"
  read_html(my_url) |> 
    html_elements(my_xml) |> 
    html_text2()
}


# Mon Feb  2 17:33:59 2026 ------------------------------

z <- extract_tables(file = "nuclear/wapstra-atomic-mass.pdf", pages = 9:60)
my_names <- z[[1]][1,]
i <- 1
mass_table <- function(i=1) {
  z1 <- z[[i]] |> as_tibble()
  if(dim(z1)[2] > 10) return(zq)
  names(z1) <- z1[1,]
  z1 <- z1[-c(1, 2),] |> 
    janitor::clean_names()
  z1 |> 
    mutate(atomic_mass = str_replace(atomic_mass, "#", ".") |> 
             str_replace(" ", "") |> 
             str_replace(" .+", "") |> 
             as.double(),
           atomic_mass = atomic_mass / 1e6)
}
zq <- mass_table(2)
zq1 <- map_df(1:52, function(i) mass_table(i))
# write_csv(zq, "nuclear/beta-masses.csv")
