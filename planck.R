library(tidyverse)
library(constants)
library(ggrepel)
library(showtext)
library(envalysis)
library(ggtext)
library(latex2exp)

font_add(family = "Ink Free", regular = "assets/Inkfree.ttf")
showtext_auto()

h <- codata[198,]$value
c0 <- codata[254, ]$value
kb <- codata[43, ]$value

lambda <- 100:2000 * 1e-9
kelvin1 <- 5777
col1 <- "#7A0403FF"
kelvin2 <- 5277
col2 <- "#18DEC1FF"
kelvin3 <- 4777
col3 <- "#3F3994FF"

u1 <- 8*pi*h*c0 / lambda^5 / (exp(h*c0/(lambda*kb*kelvin1))-1)
lambda_max1 <- lambda[which.max(u1)]*1e9
u2 <- 8*pi*h*c0 / lambda^5 / (exp(h*c0/(lambda*kb*kelvin2))-1)
lambda_max2 <- lambda[which.max(u2)]*1e9
u3 <- 8*pi*h*c0 / lambda^5 / (exp(h*c0/(lambda*kb*kelvin3))-1)
lambda_max3 <- lambda[which.max(u3)]*1e9

my_title_cols <- glue::glue("<i style='color:{col1};'> {kelvin1}K </i>,
                            <i style='color:{col2};'> {kelvin2}K </i>,
                            and <i style='color:{col3};'> {kelvin3}K </i>")
my_title <- paste0("Planck's Radiation   Law for ", my_title_cols)

tibble(lambda = lambda*1e9, u1, u2, u3) |>
  pivot_longer(-lambda, names_to = "temperature", values_to = "planck") |>
  ggplot(aes(lambda, planck, colour = temperature)) +
  geom_line(show.legend = F) +
  labs(x = TeX("$\\lambda (nm)$"),
       y = "",
       title = my_title) +
  scale_colour_manual(values = c(col1, col2, col3)) +
  geom_vline(xintercept = c(lambda_max1, lambda_max2, lambda_max3),
             linetype="dotted", size = 1, col = c(col1, col2, col3)) +
  theme_publish(base_size = 32, base_family = "Ink Free", base_linewidth = 0.7) +
  theme(axis.title.x = element_text(family = "Arial"),
        axis.text.y = element_blank(),
        plot.title = element_markdown())
