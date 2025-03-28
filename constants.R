library(constants)
library(tidyverse)

View(codata)

hbar <- codata$value[codata$symbol == "hbar"]
h0 <- hbar*2*pi
me <- codata$value[codata$symbol == "me"]
mp <- codata$value[codata$symbol == "mp"]
mn <- codata$value[codata$symbol == "mn"]
e <-  codata$value[codata$symbol == "e"]
c0 <- codata$value[codata$symbol == "c0"]
ryd <- codata$value[codata$symbol == "ryd"]
rydhcev <- codata$value[codata$symbol == "rydhcev"]
bohr <- codata$value[codata$symbol == "bohrrada0"]
u <- codata$value[codata$symbol == "u"]

meu <- 151.964*u
(63*mp + 89*mn - meu)*c0^2


lambda <- 121.6e-9
en <- h0*c0/lambda / rydhcev

n1 <- 1
n2 <- 3:10

ndiff <- 1/n1^2 - 1/n2^2
(h0*c0/(13.6*ndiff*e) *1e9) |> round(3)

en <- h0*c0/93.77e-9 / e

sqrt(rydhcev/(rydhcev - en))

# wavelengths

x0 <- 0.52
alpha0 <- 32

exp((-alpha0*x0^2)/2) * (pi/alpha0)^0.25


1/(1/3^2 - 1/4^2) / ryd * 1e9 / 16


1/7.6 *h0*c0 /e *1e9


# H gound state prob
a0=0.0529
r0 <- 0.87*a0
delta_r <- 0.01*a0
1/(a0^3*pi) * exp(-2*r0/a0) * 4*pi*r0^2*delta_r



## sho quiz

alpha <- 38
x <- 0.35
(pi/alpha)^0.25 * exp(-alpha*x^2/2)
1/2 * hbar * sqrt(83.4/me) /e
A=24
B=41
A*B/(A+B)
cm_1 <- 1899
lambda <- 1/1899/100
h0*c0/lambda / e
3.04/6.5*9.5
x <- 0.35
(H3x <- -12*x + 8*x^3)
6.66/14.5*7.5




# Fri Mar 28 09:02:35 2025 ------------------------------

#### variational sho ####

gamma <- sqrt(  sqrt(3) / 4 / sqrt(1/6 - 1/pi^2)  )

pi^2 / 8 / gamma^2 + gamma^2 * (1/6 - 1/pi^2)



# Fri Mar 28 09:02:59 2025 ------------------------------

