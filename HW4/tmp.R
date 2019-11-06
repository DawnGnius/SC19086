set.seed(111)
alpha <- .1
n <- 30
m <- 2500

sk <- function(x) {
  #computes the sample skewness coeff.
  xbar <- mean(x)
  m3 <- mean((x - xbar)^3)
  m2 <- mean((x - xbar)^2)
  return( m3 / m2^1.5 )
}


epsilon <- c(seq(0, 100, 0.5))
N <- length(epsilon)
pwr <- numeric(N)
#critical value for the skewness test
cv <- qnorm(1-alpha/2, 0, sqrt(6*(n-2) / ((n+1)*(n+3))))
for (j in 1:N) { #for each epsilon
  e <- epsilon[j]
  sktests <- numeric(m)
  for (i in 1:m) { #for each replicate
    # sigma <- sample(c(1, 10), replace = TRUE,
    #                 size = n, prob = c(1-e, e))
    # x <- rnorm(n, 0, sigma)
    x <- rbeta(n, epsilon, epsilon)
    sktests[i] <- as.integer(abs(sk(x)) >= cv)
  }
  pwr[j] <- mean(sktests)
}

#plot power vs epsilon
plot(epsilon, pwr, type = "b", xlab = bquote(alpha), ylim = c(0,1))

# plot test level line, horizon
abline(h = .1, lty = 3)

# add standard errors
se <- sqrt(pwr * (1-pwr) / m) 
lines(epsilon, pwr+se, lty = 3)
lines(epsilon, pwr-se, lty = 3)