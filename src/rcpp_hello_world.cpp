
#include <Rcpp.h>
using namespace Rcpp;

//' @name rcpp_hello_world
//' @title Simple cpp code
//' @description Simple cpp code
//' @return a List z
//' @examples
//' \dontrun{
//' rcpp_hello_world()
//' }
//' @export
//' @useDynLib StatComp19086, .registration = TRUE
// [[Rcpp::export]]
List rcpp_hello_world() {

    CharacterVector x = CharacterVector::create( "foo", "bar" )  ;
    NumericVector y   = NumericVector::create( 0.0, 1.0 ) ;
    List z            = List::create( x, y ) ;

    return z ;
}
