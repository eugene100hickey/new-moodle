library(constants)

hbar <- codata$value[codata$symbol == "hbar"]
me <- codata$value[codata$symbol == "me"]
e <-  codata$value[codata$symbol == "e"]


x0 <- 0.52
alpha0 <- 32

exp((-alpha0*x0^2)/2) * (pi/alpha0)^0.25
