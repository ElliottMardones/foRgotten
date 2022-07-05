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
List fe(NumericMatrix threshold, NumericMatrix CC, NumericMatrix CE, NumericMatrix EE,NumericMatrix M3){
    if(threshold.length() == 0 ){
        return(R_NilValue);
    }else{
        // DECLARACION DE VECTORES
        //DataFrame df;

        CharacterVector M1_rowName = rownames(CC);  // Nombres de las Filas para la matriz M1
        CharacterVector M1_colName = colnames(CC);  // Nombres de las Columnas para la matriz M1
        CharacterVector M2_rowName = rownames(CE);
        CharacterVector M2_colName = colnames(CE);  // Nombres de las Columnas para la matriz M2
        CharacterVector M3_rowName = rownames(EE);  // Nombres de las Columnas para la matriz M1
        CharacterVector M3_colName = colnames(EE);  // Nombres de las Columnas para la matriz M2

        // Debo crear row -camino -destino y mu por izquierda y derecha
        int nrowCC = CC.nrow();
        NumericVector from_left_o(     nrowCC*threshold.nrow(), NumericVector::get_na());
        NumericVector throught_left_o( nrowCC*threshold.nrow(), NumericVector::get_na());
        NumericVector to_left_o(       nrowCC*threshold.nrow(), NumericVector::get_na());
        NumericVector mu_left_o(       nrowCC*threshold.nrow(), NumericVector::get_na());
        // ahora por derecha
        int nrowsCE = CE.nrow();
        NumericVector from_right_o(     nrowsCE*threshold.nrow(), NumericVector::get_na());
        NumericVector throught_right_o( nrowsCE*threshold.nrow(), NumericVector::get_na());
        NumericVector to_right_o(       nrowsCE*threshold.nrow(), NumericVector::get_na());
        NumericVector mu_right_o(       nrowsCE*threshold.nrow(), NumericVector::get_na());
        LogicalVector RES;
        LogicalVector RES2;
        for( int x = 0; x < threshold.nrow() ; x++){
            // para izquierda
            double value_row_CC = threshold(x,0);
            double value_col_CE = threshold(x,1);
            // para derecha
            double value_row_CE = threshold(x,0);
            double value_col_EE = threshold(x,1);
            // Datos por izquierda
            NumericVector fromRow_CC =  CC(value_row_CC - 1 ,_ );
            NumericVector fromCol_CE =  CE(_, value_col_CE - 1 );
            // Datos por derecha
            NumericVector fromRow_CE =  CE(value_row_CE - 1 ,_ );
            NumericVector fromCol_EE =  EE(_, value_col_EE - 1 );
            // Union de datos por izquierda
            NumericMatrix left = cbindRcpp(fromRow_CC, fromCol_CE);
            // Union de datos por derecha
            NumericMatrix right = cbindRcpp(fromRow_CE, fromCol_EE);
            // Encontrando el val maxmin por izquierda
            NumericVector output_left(left.nrow());
            for(int i = 0; i < left.nrow(); i++){
                output_left[i] = min(left(i,_));
            }
            NumericVector maxmax_left = which_max_multiple(output_left, CC); //
            // Encontrando el val maxmin por derecha
            NumericVector output_right(right.nrow());
            for(int i = 0; i < right.nrow(); i++){
                output_right[i] = min(right(i,_));
            }
            NumericVector maxmax_right = which_max_multiple(output_right, CE); //
            // si output_left[maxmax_left] > output_right[maxmax_right], se usan los caminos de CC
            // y sino, se usan los de EE

            NumericVector A = output_left[maxmax_left];
            NumericVector B = output_right[maxmax_right];

            //RES = (A > B);
            //RES2 = (A < B);
            RES = (A >= B);
            RES2 = (A <= B);
            //print(output_left[maxmax_left]);
            //print(output_right[maxmax_right]);
            //print(A);
            //print(RES);
            //print(RES2);

            if( RES[0] == TRUE ){
                if( maxmax_left.size() > 1){
                    for( int l = 0; l < maxmax_left.size(); l ++){
                        from_left_o.push_back(value_row_CC);
                        throught_left_o.push_back(maxmax_left[l]);
                        to_left_o.push_back(value_col_CE);
                        mu_left_o.push_back(M3((value_row_CC - 1), (value_col_CE - 1)));
                    }
                }else{
                    from_left_o.push_back(value_row_CC);
                    throught_left_o.push_back((maxmax_left[0] )); //push_fron? origipush_back
                    to_left_o.push_back(value_col_CE);
                    mu_left_o.push_back(M3((value_row_CC - 1), (value_col_CE - 1)));
                }
            }
            if(RES2[0] == TRUE){
                if( maxmax_right.size() > 1){
                    for( int l = 0; l < maxmax_right.size(); l ++){
                        from_right_o.push_back(value_row_CE);
                        throught_right_o.push_back(maxmax_right[l]);
                        to_right_o.push_back(value_col_EE);
                        mu_right_o.push_back(M3((value_row_CE - 1), (value_col_EE - 1)));
                    }
                }else{
                    from_right_o.push_back(value_row_CE);
                    throught_right_o.push_back((maxmax_right[0] )); //push_fron? origipush_back
                    to_right_o.push_back(value_col_EE);
                    mu_right_o.push_back(M3((value_row_CE - 1), (value_col_EE - 1)));
                }
            }
        }
        // datos por izquierda: Eliminando na values
        from_left_o     = na_omit(from_left_o);
        throught_left_o = na_omit(throught_left_o);
        to_left_o       = na_omit(to_left_o);
        mu_left_o       = na_omit(mu_left_o);
        // Creando el vector para los datos de izquierda
        //CharacterVector From_left(from_left_o.size());
        //CharacterVector Through_left(throught_left_o.size());
        //CharacterVector To_left(to_left_o.size());
        //NumericVector Mu_left(mu_left_o.size());
        CharacterVector From_left;
        CharacterVector Through_left;
        CharacterVector To_left;
        NumericVector Mu_left;
        for(int i = 0; i < from_left_o.size(); i++){
            double from_left    = from_left_o[i] -1 ;
            double throught_left  = throught_left_o[i] ;
            double to_left      = to_left_o[i] -1 ;
            double mu_left      = mu_left_o[i];
            //From_left[i] =  M1_rowName[from_left];
            //Through_left[i]= M2_rowName[throught_left];
            //To_left[i] = M2_colName[to_left];
            //Mu_left[i] = mu_left_o[i];
            if(M1_rowName[from_left] != M2_rowName[throught_left]){
                From_left.push_back(M1_rowName[from_left]);
                Through_left.push_back(M2_rowName[throught_left]);
                To_left.push_back(M2_colName[to_left]);
                Mu_left.push_back(mu_left);
            }
        }
        DataFrame df__LEFT = DataFrame::create( Named("From") = clone(na_omit(From_left)) ,
                                                Named("Through") = clone(na_omit(Through_left)) ,
                                                Named("To") = clone(na_omit(To_left)) ,
                                                Named("Mu") = clone(na_omit(Mu_left)) );

        from_right_o     = na_omit(from_right_o);
        throught_right_o = na_omit(throught_right_o);
        to_right_o       = na_omit(to_right_o);
        mu_right_o       = na_omit(mu_right_o);
        // Creando el vector para los datos de izquierda
        //CharacterVector From_right(from_right_o.size());
        //CharacterVector Through_right(throught_right_o.size());
        //CharacterVector To_right(to_right_o.size());
        //CharacterVector Mu_right(mu_right_o.size());
        CharacterVector From_right;
        CharacterVector Through_right;
        CharacterVector To_right;
        NumericVector Mu_right;
        for(int i = 0; i < from_right_o.size(); i++){
            double from_right    = from_right_o[i] -1 ;
            double throught_right   = throught_right_o[i] ;
            double to_right       = to_right_o[i] -1 ;
            double mu_right     = mu_right_o[i];
            //asigando los valores
            //From_right[i] =  M2_rowName[from_right];
            //Through_right[i]= M2_colName[throught_right];
            //To_right[i] = M3_colName[to_right];
            //Mu_right[i] = mu_right_o[i];
            if(M2_colName[throught_right] != M3_colName[to_right]){
                From_right.push_back(M2_rowName[from_right]);
                Through_right.push_back(M2_colName[throught_right]);
                To_right.push_back(M3_colName[to_right]);
                Mu_right.push_back(mu_right);
            }
        }
        DataFrame df__RIGHT = DataFrame::create( Named("From") = clone(na_omit(From_right)) ,
                                                 Named("Through") = clone(na_omit(Through_right)) ,
                                                 Named("To") = clone(na_omit(To_right)) ,
                                                 Named("Mu") = clone(na_omit(Mu_right)) );

        List L = List::create(Named("left") = df__LEFT , _["right"] = df__RIGHT);
        return(L);
    }
}

// [[Rcpp::export]]
DataFrame fe_left(NumericMatrix valueOverThreshold, NumericMatrix M1, NumericMatrix M2,NumericMatrix M3){
    if( valueOverThreshold.length() == 0 ){
        return(R_NilValue);
    }else {
        // DECLARACION DE VECTORES
        int nrowsM1 = M1.nrow();
        CharacterVector M1_rowName = rownames(M1);
        CharacterVector M1_colName = colnames(M1);
        CharacterVector M2_colName = colnames(M2);
        CharacterVector M2_rowName = rownames(M2);
        CharacterVector M3_rowName = rownames(M3);
        CharacterVector M3_colName = colnames(M3);
        NumericVector values_row_output(nrowsM1*valueOverThreshold.nrow(), NumericVector::get_na());
        NumericVector caminos(nrowsM1*valueOverThreshold.nrow(), NumericVector::get_na());
        NumericVector values_col_output(nrowsM1*valueOverThreshold.nrow(), NumericVector::get_na());
        NumericVector values_M3_result(nrowsM1*valueOverThreshold.nrow(), NumericVector::get_na());
        for( int x = 0; x < valueOverThreshold.nrow() ; x++){
            double values_row = valueOverThreshold(x,0);
            double values_col = valueOverThreshold(x,1);
            NumericVector fromRow =  M1(values_row-1 ,_ );
            NumericVector fromCol =  M2(_, values_col-1 );
            // Cbind de las 2 variables anteriores
            NumericMatrix data = cbindRcpp(fromRow, fromCol);
            // Calculo del valor minimo
            NumericVector output(data.nrow());
            for(int i = 0; i < data.nrow(); i++){
                output[i] = min(data(i,_));
            }
            // Funcion which_max_multiple para encontrar la posicion del elemento mas grande
            NumericVector maxmax = which_max_multiple(output, M1); //
            if( maxmax.size() > 1){
                for( int l = 0; l < maxmax.size(); l ++){
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
        CharacterVector newMu(values_M3_result.size());

        for(int i = 0; i < values_row_output.size(); i++){
            double rowdata = values_row_output[i] -1 ;
            double caminos_d = caminos[i] ;
            double values_col = values_col_output[i] -1 ;
            From[i] =  M1_rowName[rowdata];
            Through[i]= M2_rowName[caminos_d];
            To[i] = M2_colName[values_col];
            newMu[i] = values_M3_result[i];

        }
        DataFrame df = DataFrame::create( Named("From") = clone(na_omit(From)) ,
                                          Named("Through") = clone(na_omit(Through)) ,
                                          Named("To") = clone(na_omit(To)) ,
                                          Named("Mu") = clone(na_omit(newMu)) );
        return(df);
    }
}


// [[Rcpp::export]]
DataFrame fe_right(NumericMatrix valueOverThreshold, NumericMatrix M1, NumericMatrix M2,NumericMatrix M3){
    if( valueOverThreshold.length() == 0 ){
        return(R_NilValue);
    }else {
        // DECLARACION DE VECTORES
        int nrowsM1 = M1.nrow();
        CharacterVector M1_rowName = rownames(M1);
        CharacterVector M1_colName = colnames(M1);
        CharacterVector M2_colName = colnames(M2);
        CharacterVector M2_rowName = rownames(M2);
        CharacterVector M3_rowName = rownames(M3);
        CharacterVector M3_colName = colnames(M3);
        NumericVector values_row_output(nrowsM1*valueOverThreshold.nrow(), NumericVector::get_na());
        NumericVector caminos(nrowsM1*valueOverThreshold.nrow(), NumericVector::get_na());
        NumericVector values_col_output(nrowsM1*valueOverThreshold.nrow(), NumericVector::get_na());
        NumericVector values_M3_result(nrowsM1*valueOverThreshold.nrow(), NumericVector::get_na());
        for( int x = 0; x < valueOverThreshold.nrow() ; x++){
            double values_row = valueOverThreshold(x,0);
            double values_col = valueOverThreshold(x,1);
            NumericVector fromRow =  M1(values_row-1 ,_ );
            NumericVector fromCol =  M2(_, values_col-1 );
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
        CharacterVector newMu(values_M3_result.size());
        for(int i = 0; i < values_row_output.size(); i++){
            double rowdata = values_row_output[i] -1 ;
            double caminos_d = caminos[i] ;
            double values_col = values_col_output[i] -1 ;
            // Almacenamiento de nombres de fila y columna para cada tipo de salida.
            From[i] =  M1_rowName[rowdata];
            Through[i]= M2_rowName[caminos_d];
            To[i] = M1_colName[values_col];
            newMu[i] = values_M3_result[i];
        }
        // CREACION Y SALIDA DE UN DATAFRAME
        DataFrame df = DataFrame::create( Named("From") = clone(na_omit(From)) ,
                                          Named("Through") = clone(na_omit(Through)) ,
                                          Named("To") = clone(na_omit(To)) ,
                                          Named("Mu") = clone(na_omit(newMu)) );
        return(df);
    }
}
