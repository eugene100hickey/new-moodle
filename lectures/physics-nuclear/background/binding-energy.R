# https://www.semanticscholar.org/paper/Understanding-Nuclear-Binding-Energy-with-Nucleon-U.V-Lakshminarayana/c424f5ef6f2590143c0f7eb48898f40313bc1102

library(tidyverse)
library(tabulizer)
library(ggrepel)
library(showtext)
library(envalysis)

font_add(family = "Ink Free", regular = "assets/Inkfree.ttf")
showtext_auto()

z <- tabulizer::extract_tables("background/nuclear/binding-energies.pdf", 
                               pages = 9, 
                               method = "decide",
                               guess = F,
                               area = list(c(480, 0, 841, 595)))[[1]] |> as_tibble()

names(z) <- c("Z_no", "Atomic_no", "N", "gamma", "B_Energy", "BE_dash", "error", "empty")
z <- z[6:24,] |> 
  select(-empty)

z1 <- tabulizer::extract_tables("background/nuclear/binding-energies.pdf", 
                               pages = 10)[[1]] |> 
  as_tibble()
names(z1) <- names(z)
z2 <- tabulizer::extract_tables("background/nuclear/binding-energies.pdf", 
                                pages = 11)[[1]] |> 
  as_tibble()
names(z2) <- names(z)

zt <- rbind(z, z1, z2)

zt1 <- zt |> 
  mutate_at(vars(Z_no:error), as.numeric) |> 
  mutate(BE_nucleon = BE_dash / Atomic_no)

elements <- tibble(Z_no = 1:100, symbol = PeriodicTable::symb(1:100))
elements <- elements |> left_join(zt1) |> 
  mutate(symbol = factor(symbol, levels = elements$symbol))
cat(paste0('"', paste(elements$symbol[60:99], collapse="\", \""), '"'))
(paste0('"', paste(elements$Atomic_no[60:99], collapse="\", \""), '"')) |> 
  str_remove_all("\"")
(paste0('"', paste(elements$BE_nucleon[60:99] |> round(4), collapse="\", \""), '"')) |> 
  str_remove_all("\"")

elements |> ggplot(aes(Atomic_no, BE_nucleon)) + 
  geom_point() + 
  geom_line() +
  scale_x_continuous(breaks = seq(0, 260, by= 20)) +
  coord_cartesian(expand = FALSE) +
  labs(title = "Binding Energy per Nucleon Across the\nLong Lived Elements and Most Common Isotopes",
       x = "Mass Number (A)",
       y = "Binding Energy per Nucleon (MeV)") +
  geom_label_repel(data = elements |> slice_sample(n=10), 
                   aes(label = symbol),
                   size = 12) +
  theme_publish(base_size = 28, base_family = "Ink Free", base_linewidth = 0.7)

elements |> ggplot(aes(symbol, BE_nucleon)) + geom_point() + geom_line(group = 1) +
  theme_publish(base_size = 16, base_family = "Times", base_linewidth = 0.7)
