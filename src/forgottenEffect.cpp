#include <Rcpp.h>
using namespace Rcpp;
using namespace std;


NumericMatrix cbindRcpp(NumericVector x, NumericVector y){
  NumericMatrix out (x.size(), 2);
  out(_,0) = x; out(_,1)=y;
  return out;
}


NumericVector which_max_multiple(NumericVector d_o, NumericMatrix M1){
  int nrowsM1 = M1.nrow();
  double current_max = max(d_o);
  NumericVector index(nrowsM1*d_o.size(), NumericVector::get_na());
  int n = d_o.length();
  for( int i = 0; i< n ; i++){
    if(d_o[i] > current_max){
      current_max = d_o[i];
      index.erase(i);
    }
    if( d_o[i] == current_max ){
      index.push_back(i);
    }
  }
  return na_omit(index);
}

// [[Rcpp::export]]
DataFrame feRcpp(NumericMatrix valueOverThreshold, NumericMatrix M1, NumericMatrix M2,NumericMatrix M3){
  if( valueOverThreshold.length() == 0 ){
    return("1");
  }else {
    // DECLARACION DE VECTORES
    int nrowsM1 = M1.nrow();
    CharacterVector M1_rowName = rownames(M1);  // Nombres de las Filas para la matriz M1
    CharacterVector M1_colName = colnames(M1);  // Nombres de las Columnas para la matriz M1
    CharacterVector M2_colName = colnames(M2);  // Nombres de las Columnas para la matriz M2
    CharacterVector M2_rowName = rownames(M2);
    CharacterVector M3_rowName = rownames(M3);  // Nombres de las Columnas para la matriz M1
    CharacterVector M3_colName = colnames(M3);  // Nombres de las Columnas para la matriz M2
    NumericVector values_row_output(nrowsM1*valueOverThreshold.nrow(), NumericVector::get_na());
    NumericVector caminos(nrowsM1*valueOverThreshold.nrow(), NumericVector::get_na());
    NumericVector values_col_output(nrowsM1*valueOverThreshold.nrow(), NumericVector::get_na());
    NumericVector values_M3_result(nrowsM1*valueOverThreshold.nrow(), NumericVector::get_na());
    for( int x = 0; x < valueOverThreshold.nrow() ; x++){
      double values_row = valueOverThreshold(x,0);
      double values_col = valueOverThreshold(x,1);
      NumericVector fromRow =  M1(values_row-1 ,_ ); // Valores de la matriz M1 (filtrado por valueOverThreshold)
      NumericVector fromCol =  M2(_, values_col-1 ); // Valores de la matriz M2 (filtrado por valueOverThreshold)
      // Cbind de las 2 variables anteriores
      NumericMatrix data = cbindRcpp(fromRow, fromCol);
      // ESTO ES UN APPLY en R: apply( vector, fila = 1, funcion = min() )
      NumericVector output(data.nrow());
      for(int i = 0; i < data.nrow(); i++){
        output[i] = min(data(i,_));
      }
      // Funcion which_max_multiple para encontrar la posicion del elemento mas grande
      NumericVector maxmax = which_max_multiple(output, M1); // solo 1 y si son 2 iguales?
      if( maxmax.size() > 1){
        for( int l = 0; l < maxmax.size(); l ++){
          //std::cout << "aca estamos?" <<std::endl;
          values_row_output.push_back(values_row);
          caminos.push_back(maxmax[l]);
          values_col_output.push_back(values_col);
          values_M3_result.push_back(M3((values_row - 1), (values_col - 1)));
        }
      }else{
        values_row_output.push_back(values_row);
        caminos.push_back((maxmax[0] ));
        values_col_output.push_back(values_col);
        values_M3_result.push_back(M3((values_row - 1), (values_col - 1)));
      }
    }
    values_row_output = na_omit(values_row_output);
    caminos = na_omit(caminos);
    values_col_output = na_omit(values_col_output);
    values_M3_result = na_omit(values_M3_result);
    // Vecteros para la salida por DataFrame
    CharacterVector From(values_row_output.size());
    CharacterVector Through(caminos.size());
    CharacterVector To(values_col_output.size());
    for(int i = 0; i < values_row_output.size(); i++){
      double rowdata = values_row_output[i] -1 ;
      double caminos_d = caminos[i] ;
      double values_col = values_col_output[i] -1 ;
      // Almacenamiento de nombres de fila y columna para cada tipo de salida.
      From[i] =  M1_rowName[rowdata];
      Through[i]= M1_colName[caminos_d]; // o puede ser M2_rownames
      To[i] = M2_colName[values_col];
    }
    // CREACION Y SALIDA DE UN DATAFRAME
    DataFrame df = DataFrame::create( Named("From") = clone(na_omit(From)) ,
                                      Named("Through") = clone(na_omit(Through)) ,
                                      Named("To") = clone(na_omit(To)) ,
                                      Named("Mu") = clone(na_omit(values_M3_result)) );
    return(df);
  }
}





