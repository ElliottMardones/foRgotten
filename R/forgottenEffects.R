#' @title FE
#' @aliases FE
#' @name FE
#'
#' @description The FE() function calculates the forgotten effects, the frequency of their occurrence,
#'  the mean incidence, the confidence intervals, and the standard error for complete and chained bipartite
#'   graphs using multiple key informants. This function implements bootstrap BCa.

#' @param CC It allows for entering a three-dimensional incidence array, with each submatrix
#' along the z-axis being a square incidence matrix. By default, CC = NULL.
#'
#' @param CE It allows for entering a three-dimensional incidence array, with each submatrix
#'  along the z-axis being a square incidence matrix (for complete graphs) or a rectangular
#'  matrix (for chained bipartite graphs).
#'
#' @param EE It allows for entering a three-dimensional incidence array, with each submatrix
#' along the z-axis being a square incidence matrix. By default, EE = NULL.
#'
#' @param mode  Specify the mode for the FE function. If the mode is set to ‘Per-Expert,’
#'  the function will calculate using all experts. If the mode is set to ‘Empirical,’ the
#'  function will utilize this method.
#'
#'
#' @param thr Defines the degree of truth in which incidence is considered significant within the range. By default, thr = 0.5.
#'
#' @param maxOrder Defines the limit of forgotten effects to calculate (if they exist). By default, maxOrder = 2.
#' @param reps Defines the number of bootstrap replicates. By default, reps = 10000.
#'
#' @param parallel Sets the type of parallel operation required. The options are “multicore”, “snow”, and “no”. By default, parallel = "no".

#' @param ncpus IDefines the number of cores to use. By default, ncpus = 1.


#'
#' @details The function extends the theory of forgotten effects proposed by Kaufmann and Gil-Aluja (1988),
#'  to find indirect cause-effect relationships from direct cause-effect relationships, in the
#'  case of multiple experts.
#' The parallel and ncpus options are not available on Windows operating systems.

#' @return The function returns a list with subsets of data.
#' $boot: List of data.frame for each of the generated commands, contains the following components:

#' \item{From}{Indicates the origin of the forgotten effects relationships.}
#' \item{Through_x}{Dynamic field representing the intermediate relationships of the forgotten effects.
#' For example, for order n there will be "Through_1" up to "Through_ <n-1>" \eqn{Through_(n-1)}.}
#' \item{To}{Indicates the end of the forgotten effects relationships.}
#' \item{Count}{Number of times the forgotten effect was repeated.}
#' \item{Mean}{Mean effect of the forgotten effect.}
#' \item{LCI}{Lower Confidence Intervals.}
#' \item{UCI}{Upper Confidence Intervals.}
#' \item{SE}{Standard error.}
#'
#'$byExperts: List of data.frames for each of the generated orders that contains the incidence
#' values for each of the relationships found by the expert, the components are:
#' \item{From}{Indicates the origin of the forgotten effects relationships.}
#' \item{Through_x}{Dynamic field representing the intermediate relationships of the forgotten effects.
#' For example, for order n there will be "Through_1" up to "Through_ <n-1>".}
#' \item{To}{Indicates the end of the forgotten effects relationships.}
#' \item{Count}{Number of times the forgotten effect was repeated.}
#' \item{Expert_x}{Dynamic field that represent each of the entered experts.}
#' @export
#'
#' @references
#' Kaufmann, A., & Aluja, J. G. (1988). Modelos para la investigación de efectos olvidados. Milladoiro.
#'
#' Canty A, Ripley BD (2021). boot: Bootstrap R (S-Plus) Functions. R package version 1.3-28.
#'
#' Csardi G, Nepusz T (2006). "The igraph software package for complex network research." InterJournal, Complex Systems, 1695
#'
#' Eddelbuettel D, Francois R (2011). "Rcpp: Seamless R and C++ Integration." Journal of Statistical Software, 40(8), 1-18.
#'
#' Eddelbuettel D (2013). Seamless R and C++ Integration with Rcpp. Springer, New York.
#'
#' Eddelbuettel D, Balamuta JJ (2018). "Extending extitR with extitC++: A Brief Introduction to extitRcpp." The American Statistician, 72(1), 28-36.6.
#'
#' @examples
#' # example code
#' # To chain bipartite graphs the parameters CC, CE and EE are used.
#' FE(CC = CC, CE = CE, EE = EE, mode = "Per-Expert", thr = 0.5, maxOrder = 2, reps = 100)
#' # To complete graphs you will need to use two dataset, for example
#' FE(CC = CC, CE = CE, EE = NULL, mode = "Per-Expert", thr = 0.5, maxOrder = 2, reps = 100)
FE <- function(CC = NULL, CE = NULL, EE = NULL, mode = c("Empirical", "Per-Expert"), thr = 0.5, maxOrder = 2, reps = 10000, parallel = c("multicore","snow","no"), ncpus = 1){
    output <- wrapper.FE( CC = CC, CE = CE, EE =EE, mode = mode, thr = thr, maxOrder = maxOrder, reps =reps , parallel =parallel , ncpus = ncpus)
    return(output)
}

