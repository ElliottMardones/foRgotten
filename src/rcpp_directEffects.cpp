#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
#include <vector>

using namespace Rcpp;
using namespace std;


// [[Rcpp::export]]
List Rcpp_directEffects(arma::cube& M, CharacterVector rownamesData, CharacterVector colnamesData, double thr, double reps) {

    vector<double> vect;
    // Call Mkinter
    Function MKinfer_boot_t_test("boot.t.test","MKinfer");

    // Declaration of variables
    CharacterVector From;
    CharacterVector To;
    NumericVector Mean;
    NumericVector UCI_real;
    NumericVector p__value;

    //  Triple loop for cycle
    for (unsigned int x = 0; x < M.n_rows; x++) {
        for (unsigned int y = 0; y < M.n_cols; y++) {
            if (x != y) {
                for (unsigned int z = 0; z < M.n_slices; z++) {
                    vect.push_back(M(x, y, z));
                }

                vector<double> vect_sample = vect;
                // case 1: Si el valor es unico no se hace el calculo
                sort(vect_sample.begin(), vect_sample.end());
                vect_sample.erase(unique(vect_sample.begin(), vect_sample.end()), vect_sample.end());

                if (vect_sample.size() == 1) {
                    From.push_back( rownamesData[x] );
                    To.push_back( colnamesData[y] );
                    Mean.push_back( vect[0] );
                    UCI_real.push_back( NA_REAL );
                    p__value.push_back( NA_REAL );
                } else {
                    // Se hace el calculo con mkinfer
                    List Data_CI = MKinfer_boot_t_test(Named("x")=vect,Named("alternative")="less",Named("mu")=thr,Named("R")=reps);
                    NumericVector bootConfInt = as<NumericVector>(Data_CI["boot.conf.int"]);
                    double UCI = bootConfInt[1];

                    NumericVector boot_p_value = as<NumericVector>(Data_CI["boot.p.value"]);

                    double p_value = boot_p_value[0];

                    // Se llenan los vectores
                    From.push_back( rownamesData[x] );
                    To.push_back( colnamesData[y] );
                    Mean.push_back( accu(arma::vec(vect)/vect.size()) );
                    UCI_real.push_back( UCI );
                    p__value.push_back( p_value );



                }
                vect.resize(0);
            }
        }
    }
    // retorna una lista de vectores ( en R se pasa a data.frame)
    return Rcpp::List::create(Rcpp::Named("From") = From,
                              Rcpp::Named("To") = To,
                              Rcpp::Named("Mean") = Mean,
                              Rcpp::Named("UCI") = UCI_real,
                              Rcpp::Named("p.value") = p__value);
}
