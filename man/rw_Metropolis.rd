\name{rw_Metropolis}
\alias{rw_Metropolis}
\docType{package}
\title{
Rcpp version of random walk Metropolis sampler
}
\description{
Rcpp version of random walk Metropolis sampler for generating the standard Laplace distribution
}
\usage{
rw_Metropolis()	
}
\examples{
\dontrun{
sigma <- 2
x0 <- 25
N <- 2000
res <- rw_Metropolis(sigma, x0, N)
}
}
