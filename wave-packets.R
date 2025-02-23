library(tidyverse)
library(showtext)
library(envalysis)
library(latex2exp)

font_add(family = "Ink Free", regular = "assets/Inkfree.ttf")
showtext_auto()

central <- 20
step <- 0.5
n <- 50
w <- 1/seq(central-n*step/2, central+n*step/2, by = step)
z <- -3000:3000

a <- map(1:n, function(index) sin(z*w[index])) |>
  data.frame() |>
  rowwise() |>
  mutate(total = sum(c_across(everything())))


tibble(z, amp = a$total) |> ggplot(aes(z, amp)) +
  geom_line() +
  labs(x = "Distance (m)",
       y = "Amplitude") +
  theme_publish(base_size = 28, base_family = "Ink Free", base_linewidth = 0.7) +
  theme(axis.line.x = element_blank(),
        axis.text.x = element_blank(),
        axis.ticks.x = element_blank())

