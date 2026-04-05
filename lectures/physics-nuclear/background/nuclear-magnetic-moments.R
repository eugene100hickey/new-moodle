library(tidyverse)
library(tabulizer)
library(janitor)
library(gt)

my_file <- "lectures/physics-nuclear/background/nuclear-moments.pdf"

magn_moments <- function(i) {
  z <- extract_tables(my_file, pages = i)[[1]] |>
    as_tibble() |>
    filter(V1 != "")
  z <- z[, 1:5]
  names(z) <- c("Nucleus", "Ex", "T1/2", "I", "μ(nm)" )
  z |>
    filter(Nucleus != "Nucleus")
}

#z <- map_df(10:151, function(i) magn_moments(i))
z <- read_csv("lectures/physics-nuclear/background/nuclear-moments.csv")

z <- z |>
  mutate(Z = str_extract(Nucleus, "(^|\\s)([0-9]+)($|\\s)") |> str_trim(),
         A = str_extract(Nucleus, "($|\\s)([0-9]+)($|\\s)") |> str_trim(),
         symbol = str_extract(Nucleus, "[a-zA-Z]+"),
         latex = glue::glue("$^open{A}close_open{Z}close{symbol}$"),
         latex = str_replace_all(latex, "open", "{"),
         latex = str_replace_all(latex, "close", "}"))

z1 <- z |> filter(Ex == 0)
cat(paste0('"', paste(z2$latex, collapse="\", \""), '"'))
z2 <- z |>
  filter(as.numeric(A) %% 2 == 0, as.numeric(Z) %% 2 == 0)


zq <- z |>
  janitor::clean_names() |>
  select(latex, ex, t1_2, i, m_nm, z)

#write_csv(zq, "lectures/physics-nuclear/background/nuclear-moments-table.csv")
