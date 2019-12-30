#' @title A KDE bw selection for one dim
#' @description A KDE bw selection for one dim
#' @param xx the point to be estimated
#' @param x data points
#' @param h.init initial smooth parameter
#' @return h selected by this method
#' @examples
#' \dontrun{
#' set.seed(111)
#' n <- 200
#' Num.Cmp <- 8
#' pro <- rep(1/8, Num.Cmp)
#' multi <- sample(1:Num.Cmp, n, replace = T, prob=pro)
#' mu <- 3 * ((2/3)^(1:Num.Cmp) - 1)
#' sigma <- (2/3)^(1:Num.Cmp)
#' x <- NULL
#' for (ii in 1:Num.Cmp) {
#'   com_txt <- paste("com", ii, " <- rnorm(length(which(multi==", ii, ")), mean=", mu[ii], ", sd=", sigma[ii], ")",sep="")
#'   eval(parse(text=com_txt))
#'   com_txt <- paste("x <- c(x, com", ii, ")", sep="")
#'   eval(parse(text=com_txt))
#' }
#' 
#' # true density function, y is h, and z is v.
#' y <- seq(-3, 1, 0.01)
#' z <- rep(0, length(y))
#' for (ii in 1:Num.Cmp) {
#'   z <- z + pro[ii] * dnorm(y, mean=mu[ii], sd=sigma[ii])
#' }
#' t <- seq(-3, 1, 0.05)
#' h <- unlist(base::lapply(X=t, FUN=rodeo.local.bw1, x=x))
#' plot(t, h, "l", main="Bandwidth of Rodeo", xlab="x", ylab="h")
#' }
#' @export
rodeo.local.bw1 <- function(xx, x, h.init=1.3/log(log(n)), beta=0.9, cn=log(n)/n){
  h1 <- h.init
  while(TRUE){
    Z.i <- ((xx - x)^2 - h1^2) * exp(- (xx - x)^2 / h1^2 / 2) / h1^4 / sqrt(2*pi)
    Z <- mean(Z.i) 
    s <- var(Z.i)
    lam <- sqrt(2*s*log(n*cn)) / 10
    if (abs(Z) > lam) {
      h1 <- h1 * beta
    } else {
      return(h1)
    }
  }
}


#' @title A KDE method for one dim
#' @description A KDE method for one dim
#' @param t target points, a vector
#' @param x data points, vector
#' @return a vector of estimated f(x)
#' @examples
#' \dontrun{
#' set.seed(111)
#' n <- 200
#' Num.Cmp <- 8
#' pro <- rep(1/8, Num.Cmp)
#' multi <- sample(1:Num.Cmp, n, replace = T, prob=pro)
#' mu <- 3 * ((2/3)^(1:Num.Cmp) - 1)
#' sigma <- (2/3)^(1:Num.Cmp)
#' x <- NULL
#' for (ii in 1:Num.Cmp) {
#'   com_txt <- paste("com", ii, " <- rnorm(length(which(multi==", ii, ")), mean=", mu[ii], ", sd=", sigma[ii], ")",sep="")
#'   eval(parse(text=com_txt))
#'   com_txt <- paste("x <- c(x, com", ii, ")", sep="")
#'   eval(parse(text=com_txt))
#' }
#' 
#' # true density function, y is h, and z is v.
#' y <- seq(-3, 1, 0.01)
#' z <- rep(0, length(y))
#' for (ii in 1:Num.Cmp) {
#'   z <- z + pro[ii] * dnorm(y, mean=mu[ii], sd=sigma[ii])
#' }
#' t <- seq(-3, 1, 0.05)
#' h <- unlist(base::lapply(X=t, FUN=rodeo.local.bw1, x=x))
#' plot(t, h, "l", main="Bandwidth of Rodeo", xlab="x", ylab="h")
#' }
#' @export
rodeo.local1 <- function(t, x){
  # estimate target points t
  # para: t   target points, a vector
  # para: x   data points, a vector
  h <- unlist(base::lapply(X=t, FUN=rodeo.local.bw1, x=x))
  K <- stats::dnorm
  f.hat <- unlist(base::lapply(X=1:length(t), FUN=function(ii) mean(K((t[ii] - x) / h[ii]))/ h[ii]))
  return(f.hat)
}
