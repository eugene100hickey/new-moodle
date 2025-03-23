library(constants)

hbar <- codata$value[codata$symbol == "hbar"]
h0 <- hbar*2*pi
me <- codata$value[codata$symbol == "me"]
e <-  codata$value[codata$symbol == "e"]
c0 <- codata$value[codata$symbol == "c0"]
ryd <- codata$value[codata$symbol == "ryd"]
bohr <- codata$value[codata$symbol == "bohrrada0"]


x0 <- 0.52
alpha0 <- 32

exp((-alpha0*x0^2)/2) * (pi/alpha0)^0.25


1/(1/3^2 - 1/4^2) / ryd * 1e9 / 16


1/7.6 *h0*c0 /e *1e9

