library(tidyverse)


x <- seq(-5, 5, by = 0.01)
h3 <- -12*x + 8*x^3
n3 <- sqrt(1/(2^3*6*sqrt(pi)))
psi <- n3 * h3 * exp(-x^2/2)

wave <- tibble(x, psi, my_exp = exp(-x^2/2))

wave |> ggplot(aes(x, psi)) +
  geom_line()
