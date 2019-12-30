library(MASS)
library(snowfall)
library(ggplot2)
library(L1pack)

#' @title A implement of FDP and limit FDP at t
#' @description A implement of FDP and limit FDP at t
#' @param t the point to be estimated
#' @return a list of FDP and limit FDP
#' @import L1pack
#' @import ggplot2
#' @import MASS
#' @import snowfall
#' @examples
#' \dontrun{
#' set.seed(12345)
#' n <- 100; rho <- 0.5; sig <- 2; p.nonzero <- 10; beta.nonzero <- 1; p <- 100
#' beta <- c(rep(beta.nonzero, p.nonzero), rep(0, p-p.nonzero))
#' Sigma <- matrix(rep(rho, p*p), p, p); diag(Sigma) <- rep(1, p)
#' dat <- MASS::mvrnorm(n, rep(0,p), Sigma)
#' Sigma.eigen <- eigen(Sigma)
#' mu <- unlist(base::lapply(X=1:p, FUN=function(ii) sqrt(n)*beta[ii]*sqrt(var(dat[, ii]))/sig))
#' my.fdp(0.01)
#' }
#' @export
my.fdp <- function(t){
    ##  FDP
    Z <- MASS::mvrnorm(1, mu, Sigma)
    pvalue <- unlist(base::lapply(X=1:p, FUN=function(ii) 1-pnorm(abs(Z[ii]))))
    tmp.pvalue <- pvalue[(1+p.nonzero):p]
    re1 <- length(which(tmp.pvalue < t)) / length(which(pvalue < t))
    
    ##  FDP_lim
    # k is dimension of W
    k <- 2
    # m.idx contains smallest 90% of |zi|’s indexes
    m.idx <- order(abs(Z), decreasing=TRUE)[(0.1*p+1):p]
    # x is the first k cols, eq(22)
    x.tmp <- (diag(sqrt(Sigma.eigen$values)) %*% Sigma.eigen$vectors)[m.idx, 1:k]
    y.tmp <- Z[m.idx]
    # L1 regression by eq(23)
    W <- L1pack::l1fit(x=x.tmp, y=y.tmp, intercept=FALSE)$coefficients
    # b is given by eq(22)
    b <- diag(sqrt(Sigma.eigen$values)) %*% Sigma.eigen$vectors[, 1:k]
    # numerator is given by eq(12)
    numerator <- sum(unlist(base::lapply(X=1:p.nonzero, FUN=function(ii) {
        ai <- (1 - sum((b[ii, ])^2))^(-0.5)
        pnorm(ai*(qnorm(t/2) + b[ii,] %*% W)) + pnorm(ai*(qnorm(t/2) - 
                                                              b[ii,] %*% W))})))
    # eq(12)
    denominator <- sum(unlist(base::lapply(X=1:p, FUN=function(ii) {
        ai <- (1 - sum((b[ii, ])^2))^(-0.5)
        pnorm(ai*(qnorm(t/2) + b[ii,] %*% W + mu[ii])) + 
            pnorm(ai*(qnorm(t/2) - b[ii,] %*% W - mu[ii]))})))
    # eq(12)
    re2 <- numerator / denominator
    return(rbind(re1, re2))
}

#' @title A full experient using my.fdp()
#' @description A full experient using my.fdp()
#' @param p Number of parameters in the linear model
#' @param t point to be estimated
#' @return plots
#' @examples
#' \dontrun{
#' set.seed(12345)
#' n <- 100; rho <- 0.5; sig <- 2; p.nonzero <- 10; beta.nonzero <- 1
#' my.plot(p=100, t=0.01)
#' }
#' @export
my.plot <- function(p, t){
    # Equal correlation
    beta <- c(rep(beta.nonzero, p.nonzero), rep(0, p-p.nonzero))
    Sigma <- matrix(rep(rho, p*p), p, p); diag(Sigma) <- rep(1, p)
    dat <- MASS::mvrnorm(n, rep(0,p), Sigma)
    Sigma.eigen <- eigen(Sigma)
    mu <- unlist(base::lapply(X=1:p, FUN=function(ii) 
        sqrt(n)*beta[ii]*sqrt(var(dat[, ii]))/sig))
    
    # parallel calculation
    snowfall::sfInit(parallel = TRUE, cpus = 3)
    snowfall::sfLibrary(MASS)
    snowfall::sfLibrary(L1pack)
    snowfall::sfExport("p", "mu", "Sigma", "t", "p.nonzero", "Sigma.eigen", "rho")
    fdp.repeat <- unlist(snowfall::sfLapply(rep(0.01, 100), my.fdp))
    snowfall::sfStop()
    
    # figure
    tmp.data <- data.frame(fdp=fdp.repeat[(1:p)*2-1])
    tmp.data.lim <- data.frame(fdp=fdp.repeat[(1:p)*2])
    pic <- ggplot()
    # pic <- pic + geom_histogram(data=tmp.data, aes(fdp, y=..density..), bins=5, 
    #                             color=1, alpha=0.1) 
    pic <- pic + geom_histogram(data=tmp.data.lim, aes(fdp, y=..density..),
                                bins=5, color=2, alpha=0.5)
    pic <- pic + ggtitle(paste("FDP with p=", p, "t=", t, sep=' '))
    plot(pic)
}
