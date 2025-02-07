library(tidyverse)
library(matlab)

numbers <- 1:1e4
z <- numbers[isprime(numbers)==1]

zq <- expand.grid(z, z) |>
  mutate(double_prime = Var1*Var2)

zq |> ggplot(aes(double_prime)) +
  geom_density()

z1 <- tibble(primes = z)

z1 |> ggplot(aes(primes)) +
  geom_density()
