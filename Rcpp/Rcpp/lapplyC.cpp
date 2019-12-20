#include <Rcpp.h>
using namespace Rcpp;
// [[Rcpp::export]]
List lapplyC(List input, Function f) {
  int n = input.size();
  List out(n);
  for(int i = 0; i < n; i++) {
    out[i] = f(input[i]);
  }
  return out;
}
