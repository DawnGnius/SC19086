#include <stdio.h>
using namespace std;
// [[Rcpp::export]]
double meanC(int x[]) {
  int n = x.size();
  double total = 0;
  for(int i = 0; i < n; ++i) {
    total += x[i];
  }
  return total / n;
}

int main(){
    x = int[1, 2, 3];
    printf(meanC(x));
    return 0;
}

