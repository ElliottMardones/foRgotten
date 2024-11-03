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
List fe(NumericMatrix threshold, NumericMatrix CC, NumericMatrix CE, NumericMatrix EE, NumericMatrix M3){
    if(threshold.length() == 0){
        return R_NilValue;
    }else{
        // 1) Obtener nombres de filas y columas de las matrices ingresadas
        CharacterVector rownames_CC = rownames(CC);
        CharacterVector colnames_CC = colnames(CC);
        //
        CharacterVector rownames_CE = rownames(CE);
        CharacterVector colnames_CE = colnames(CE);
        //
        CharacterVector rownames_EE = rownames(EE);
        CharacterVector colnames_EE = colnames(EE);
        // 2) Crear vectores con el espacio de la maxima cantidad posible de soluciones.
        // LEFT
        // left_0 -> From, left_1 -> through, left_2 -> To, left_3 -> Mu
        int nrowCC = CC.nrow();
        int dim_left = nrowCC*threshold.nrow();
        NumericVector left_0( dim_left, NumericVector::get_na() );
        NumericVector left_1( dim_left, NumericVector::get_na() );
        NumericVector left_2( dim_left, NumericVector::get_na() );
        NumericVector left_3( dim_left, NumericVector::get_na() );
        //
        // RIGHT
        // right_0 -> From, right_1 -> through, right_2 -> To, right_3 -> Mu
        int nrowCE = CE.nrow();
        int dim_right = nrowCE*threshold.nrow();
        NumericVector right_0( dim_right, NumericVector::get_na() );
        NumericVector right_1( dim_right, NumericVector::get_na() );
        NumericVector right_2( dim_right, NumericVector::get_na() );
        NumericVector right_3( dim_right, NumericVector::get_na() );
        //
        // Creacion de dos vectores logicos que todavia no explico bien como funcionan
        LogicalVector RES;
        LogicalVector RES2;
        //
        // 3) Recorrer las filas de threshold para obtener los indices con los valores.
        for( int x = 0; x < threshold.nrow(); x++ ){
            // Datos por izquierda
            NumericVector row_CC = CC( (threshold(x,0) -1) , _ );
            NumericVector col_CE = CE( _, (threshold(x,1) - 1)) ;
            // Datos por derecha
            NumericVector row_CE = CE( (threshold(x,0) -1) , _ );
            NumericVector col_EE = EE( _ , (threshold(x,1) -1) );
            // 3.1) Preparacion para encontrar los caminos con maxmin multiple.
            // IZQUIERDA
            NumericMatrix left  = cbindRcpp(row_CC, col_CE);
            // DERECHA
            NumericMatrix right = cbindRcpp(row_CE, col_EE);
            //
            // maxmin multiple por izquierda
            NumericVector left_min(left.nrow());
            for(int i = 0; i < left.nrow(); i++ ){
                left_min[i] = min(left( i , _ ));
            }
            NumericVector left_max = which_max_multiple(left_min, CC);
            // maxmin multiple por derecha
            NumericVector right_min(right.nrow());
            for(int i = 0; i < right.nrow(); i ++ ){
                right_min[i]  = min(right(i, _ ));
            }
            NumericVector right_max = which_max_multiple(right_min, CE);
            //
            //
            // IDENTIFICAR POR CUAL CAMINO SE FUERON LOS DATOS.
            NumericVector A = left_min[left_max];
            NumericVector B = right_min[right_max];
            //
            RES = (A >= B);
            RES2 = (A <= B);
            if( RES[0] == TRUE){
                if( left_max.size() > 1 ){
                    for(int i = 0; i < left_max.size(); i++){
                        left_0.push_back(threshold(x,0) -1);
                        left_1.push_back(left_max[i]);
                        left_2.push_back(threshold(x,1) -1);
                        left_3.push_back(M3((threshold(x,0) - 1), (threshold(x,1) - 1)));
                    }
                }else{
                    left_0.push_back(threshold(x,0) -1);
                    left_1.push_back(left_max[0]);
                    left_2.push_back(threshold(x,1) -1 );
                    left_3.push_back(M3((threshold(x,0) - 1), (threshold(x,1) - 1)));
                }
            }
            else if( RES2[0] == TRUE){
                if( right_max.size() > 1 ){
                    for(int i = 0; i < right_max.size(); i++ ){
                        right_0.push_back(threshold(x,0) -1);
                        right_1.push_back(right_max[i]);
                        right_2.push_back(threshold(x,1) -1 );
                        right_3.push_back(M3((threshold(x,0) - 1), (threshold(x,1) - 1)));
                    }
                }else{
                    right_0.push_back(threshold(x,0) -1 );
                    right_1.push_back(right_max[0]);
                    right_2.push_back(threshold(x,1) -1 );
                    right_3.push_back(M3((threshold(x,0) - 1), (threshold(x,1) - 1)));
                }
            }
        }
        // 4) ORDENAR LOS DATOS EN SUS RESPECTIVAS SALIDAS
        // 4.1) Primero por izquierda
        left_0 = na_omit(left_0);
        left_1 = na_omit(left_1);
        left_2 = na_omit(left_2);
        left_3 = na_omit(left_3);
        // Preparando los row and col names
        CharacterVector left_FROM;
        CharacterVector left_THROUGH;
        CharacterVector left_TO;
        NumericVector left_MU;
        for( int i = 0; i < left_0.size(); i++){
            double from = left_0[i] ;
            double thought = left_1[i];
            double to = left_2[i] ;
            double mu = left_3[i];
            //
            if(rownames_CC[from] != rownames_CE[thought]){
                left_FROM.push_back(rownames_CC[from]);
                left_THROUGH.push_back(rownames_CE[thought]);
                left_TO.push_back(colnames_CE[to]);
                left_MU.push_back(mu);
            }
        }
        DataFrame df__LEFT = DataFrame::create(
            Named("From") = clone(na_omit(left_FROM)),
            Named("Through") = clone(na_omit(left_THROUGH)),
            Named("To") = clone(na_omit(left_TO)),
            Named("Mu") = clone(na_omit(left_MU))
        );

        ////////////////////////////////////////////////////////////////////////////
        // RIGHT
        ////////////////////////////////////////////////////////////////////////////
        // 4) ORDENAR LOS DATOS EN SUS RESPECTIVAS SALIDAS
        right_0 = na_omit(right_0);
        right_1 = na_omit(right_1);
        right_2 = na_omit(right_2);
        right_3 = na_omit(right_3);
        // Preparando los row and col names
        CharacterVector right_FROM;
        CharacterVector right_THROUGH;
        CharacterVector right_TO;
        NumericVector right_MU;
        for( int i = 0; i < right_0.size(); i++){
            double from = right_0[i] ;
            double thought = right_1[i];
            double to = right_2[i] ;
            double mu = right_3[i];
            //
            if(colnames_CE[thought] != colnames_EE[to]){
                right_FROM.push_back(rownames_CE[from]);
                right_THROUGH.push_back(colnames_CE[thought]);
                right_TO.push_back(colnames_EE[to]);
                right_MU.push_back(mu);
            }
        }
        DataFrame df__RIGHT = DataFrame::create(
            Named("From") = clone(na_omit(right_FROM)),
            Named("Through") = clone(na_omit(right_THROUGH)),
            Named("To") = clone(na_omit(right_TO)),
            Named("Mu") = clone(na_omit(right_MU))
        );
        List L = List::create(Named("left") = df__LEFT , _["right"] = df__RIGHT);
        return(L);
    }
}

// [[Rcpp::export]]
DataFrame fe_left(NumericMatrix threshold, NumericMatrix CC, NumericMatrix CE,NumericMatrix M3){
    if( threshold.length() == 0 ){
        return(R_NilValue);
    }else {
        // 1) Obtener nombres de filas y columas de las matrices ingresadas
        CharacterVector rownames_CC = rownames(CC);
        CharacterVector colnames_CC = colnames(CC);
        //
        CharacterVector rownames_CE = rownames(CE);
        CharacterVector colnames_CE = colnames(CE);
        // 2) Crear vectores con el espacio de la maxima cantidad posible de soluciones.
        // LEFT
        // left_0 -> From, left_1 -> through, left_2 -> To, left_3 -> Mu
        int nrowCC = CC.nrow();
        int dim_left = nrowCC*threshold.nrow();
        NumericVector left_0( dim_left, NumericVector::get_na() );
        NumericVector left_1( dim_left, NumericVector::get_na() );
        NumericVector left_2( dim_left, NumericVector::get_na() );
        NumericVector left_3( dim_left, NumericVector::get_na() );
        // Creacion de dos vectores logicos que todavia no explico bien como funcionan
        LogicalVector RES;
        LogicalVector RES2;
        //
        // 3) Recorrer las filas de threshold para obtener los indices con los valores.
        for( int x = 0; x < threshold.nrow(); x++ ){
            // Datos por izquierda
            NumericVector row_CC = CC( (threshold(x,0) -1) , _ );
            NumericVector col_CE = CE( _, (threshold(x,1) - 1)) ;

            // 3.1) Preparacion para encontrar los caminos con maxmin multiple.
            // IZQUIERDA
            NumericMatrix left  = cbindRcpp(row_CC, col_CE);
            //
            // maxmin multiple por izquierda
            NumericVector left_min(left.nrow());
            for(int i = 0; i < left.nrow(); i++ ){
                left_min[i] = min(left( i , _ ));
            }
            NumericVector left_max = which_max_multiple(left_min, CC);
            // IDENTIFICAR POR CUAL CAMINO SE FUERON LOS DATOS.
            if( left_max.size() > 1 ){
                for(int i = 0; i < left_max.size(); i++){
                    left_0.push_back(threshold(x,0) -1);
                    left_1.push_back(left_max[i]);
                    left_2.push_back(threshold(x,1) -1);
                    left_3.push_back(M3((threshold(x,0) - 1), (threshold(x,1) - 1)));
                }
            }else{
                left_0.push_back(threshold(x,0) -1);
                left_1.push_back(left_max[0]);
                left_2.push_back(threshold(x,1) -1 );
                left_3.push_back(M3((threshold(x,0) - 1), (threshold(x,1) - 1)));
            }
        }
        // 4) ORDENAR LOS DATOS EN SUS RESPECTIVAS SALIDAS
        // 4.1) Primero por izquierda
        left_0 = na_omit(left_0);
        left_1 = na_omit(left_1);
        left_2 = na_omit(left_2);
        left_3 = na_omit(left_3);
        // Preparando los row and col names
        CharacterVector left_FROM;
        CharacterVector left_THROUGH;
        CharacterVector left_TO;
        NumericVector left_MU;
        for( int i = 0; i < left_0.size(); i++){
            double from = left_0[i] ;
            double thought = left_1[i];
            double to = left_2[i] ;
            double mu = left_3[i];
            //
            if(rownames_CC[from] != rownames_CE[thought]){
                left_FROM.push_back(rownames_CC[from]);
                left_THROUGH.push_back(rownames_CE[thought]);
                left_TO.push_back(colnames_CE[to]);
                left_MU.push_back(mu);
            }
        }
        DataFrame df__LEFT = DataFrame::create(
            Named("From") = clone(na_omit(left_FROM)),
            Named("Through") = clone(na_omit(left_THROUGH)),
            Named("To") = clone(na_omit(left_TO)),
            Named("Mu") = clone(na_omit(left_MU))
        );
        return(df__LEFT);
    }
}
// [[Rcpp::export]]
DataFrame fe_right(NumericMatrix threshold, NumericMatrix CE, NumericMatrix EE, NumericMatrix M3) {
    if (threshold.length() == 0) {
        return R_NilValue;
    } else {
        // 1) Obtener nombres de filas y columnas de las matrices ingresadas
        CharacterVector rownames_CE = rownames(CE);
        CharacterVector colnames_CE = colnames(CE);

        CharacterVector rownames_EE = rownames(EE);
        CharacterVector colnames_EE = colnames(EE);

        // 2) Crear vectores vacíos para almacenar los resultados
        NumericVector right_0;
        NumericVector right_1;
        NumericVector right_2;
        NumericVector right_3;

        // 3) Recorrer las filas de threshold para obtener los índices con los valores
        for (int x = 0; x < threshold.nrow(); x++) {
            // Datos por derecha
            NumericVector row_CE = CE((threshold(x, 0) - 1), _);
            //NumericVector col_EE = EE(_, (threshold(x, 1) - 1));
            // El de arriba es el antiguo pero realmente deberia ser con CE siempre
            NumericVector col_EE = EE(_, (threshold(x, 1) - 1));

            // Preparación para encontrar los caminos con maxmin múltiple
            NumericMatrix right = cbindRcpp(row_CE, col_EE);


            // Rcpp::Rcout << "right " << right <<  std::endl;
            // Maxmin múltiple por derecha
            NumericVector right_min(right.nrow());
            for (int i = 0; i < right.nrow(); i++) {
                right_min[i] = min(right(i, _));
            }
            // Imprimir el right_min
            // Rcpp::Rcout << "right_min " << right_min <<  std::endl;



            NumericVector right_max = which_max_multiple(right_min, CE);
            // Imprimir el right_max
            //Rcpp::Rcout << "right_max " << right_max <<  std::endl;


            // Identificar por cuál camino se fueron los datos
            for (int i = 0; i < right_max.size(); i++) {
                right_0.push_back(threshold(x, 0) - 1);
                right_1.push_back(right_max[i]);
                right_2.push_back(threshold(x, 1) - 1);
                right_3.push_back(M3((threshold(x, 0) - 1), (threshold(x, 1) - 1)));
            }
        }

        // 4) Ordenar los datos en sus respectivas salidas
        // Preparando los nombres de filas y columnas
        CharacterVector right_FROM;
        CharacterVector right_THROUGH;
        CharacterVector right_TO;
        NumericVector right_MU;
        for (int i = 0; i < right_0.size(); i++) {
            int from = static_cast<int>(right_0[i]);
            int through = static_cast<int>(right_1[i]);
            int to = static_cast<int>(right_2[i]);
            double mu = right_3[i];

            // Evitar que 'Through' y 'To' sean iguales
            // Imprimir los valores actuales
            //Rcpp::Rcout << "Iteración " << i << ": rownames_CE[through] = " << rownames_CE[through] << ", colnames_EE[to] = " << colnames_EE[to] <<  std::endl;

            if (rownames_CE[through] != colnames_EE[to]) {
                right_FROM.push_back(rownames_CE[from]);
                right_THROUGH.push_back(rownames_CE[through]); // Corrección aplicada aquí
                right_TO.push_back(colnames_EE[to]);
                right_MU.push_back(mu);
            }
        }

        DataFrame df__RIGHT = DataFrame::create(
            Named("From") = clone(na_omit(right_FROM)),
            Named("Through") = clone(na_omit(right_THROUGH)),
            Named("To") = clone(na_omit(right_TO)),
            Named("Mu") = clone(na_omit(right_MU))
        );
        return df__RIGHT;
    }
}
