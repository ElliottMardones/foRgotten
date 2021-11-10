#include <Rcpp.h>
using namespace Rcpp;
using namespace std;

//' @useDynLib foRgotten, .registration=TRUE
// [[Rcpp::export]]
NumericMatrix maxminRcpp(NumericMatrix matrix_1, NumericMatrix matrix_2) {
  int n = matrix_1.nrow();
  int m = matrix_1.ncol();
  int l = matrix_2.ncol();
  CharacterVector M1_rowName = rownames(matrix_1);
  CharacterVector M1_colName = colnames(matrix_2);
  NumericMatrix A(n,l);
  for( int i = 0; i< n ; i++ ){
    for( int k=0; k < l; k++){
      NumericVector temp;
      for( int j = 0; j < m; j++){
        temp.push_front(min(matrix_1(i,j), matrix_2(j,k)));
      }
      A(i,k) = max(temp);
    }
  }
  rownames(A) = M1_rowName;
  colnames(A) = M1_colName;
  return (A);
}
