#include <Rcpp.h>
using namespace Rcpp;
// [[Rcpp::export]]
List myfun(double sigma, double x0, int N) {
    NumericVector x(N);
    x[0] = x0;
    Function myrunif("runif");
    Function myrnorm("rnorm");
    NumericVector u = myrunif(Named("n") = N);
    int k = 0;
    for (int i=1; i<N; i++) {
        NumericVector y = myrnorm(Named("n")=1, Named("mean")=x[i-1], Named("sd")=sigma);
        NumericVector tmp1 = exp(-abs(y[0]));
        NumericVector tmp2 = exp(-abs(x[i-1]));
        // Rprintf("%f \t %f \t %f \t %f \t %f \n", x[i-1], y[0], u[i], exp(abs(x[i-1]) - abs(y[0])), tmp2[0]);
        if (u[i] <= (exp(abs(x[i-1]) - abs(y[0])))) {
            x[i] = y[0];
        } else {
            x[i] = x[i-1];
            k++;
        }
    }
    return List::create(Named("x")=x, Named("k")=k);
}