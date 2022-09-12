#' @title FE
#' @aliases FE
#' @name FE
#'
#' @description Performs the forgotten effects calculation proposed by Kaufman and Gil-Aluja (1988)
#'  with multiple experts. The parameters allow you to specify the significant degree of truth and
#'  the order of incidence that is required to be calculated for chained bipartite graphs.
#'   The function returns the frequency of appearance of the forgotten effect, its mean incidence,
#'    the confidence intervals and the standard error in each order.

#' @param CC Three-dimensional matrix, where each submatrix along the z-axis is a square and
#' reflective incidence matrix, or a list of data.frames containing square and reflective
#' incidence matrices. Each matrix represents a complete graph.
#'
#' @param CE Three-dimensional matrix, where each submatrix along the z-axis is a rectangular
#'  incidence matrix, or a list of data.frames containing rectangular incidence matrices.
#'  Each matrix represents a bipartite graph.
#'
#' @param EE Three-dimensional matrix, where each submatrix along the z-axis is a square
#' and reflective incidence matrix, or a list of data.frames containing square and reflective
#' incidence matrices. Each matrix represents a complete graph.
#'
#' @param thr Real between [0,1]: Defines the degree of truth for which the incidence
#' is considered significant. By default thr = 0.5.

#' @param maxOrder Positive integer greater than 1: Defines the maximum order
#'  of the forgotten effects. By default maxOrder = 2.

#' @param reps The number of bootstrap replicas. By default reps = 10.000.

#' @param parallel The type of parallel operation to use (if applicable).
#' The options are "multicore", "snow" and "no". By default parallel = "no".

#' @param ncpus Integer: Number of processes that will be used in the parallel
#' implementation. By default ncpus = 1.


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
#' # To perform the calculation of the forgotten effects for a chain bipartite graph with
#' # a degree of truth equal to 0.5, maximum order of effects to be calculated equal to 2 and
#' # 500 bootstrap replicas, use:
#' FE( CC = CC, CE = CE, EE = EE, thr = 0.5, maxOrder = 2, reps = 500, parallel = "no", ncpus = 1)
FE <- function(CC = NULL, CE = NULL, EE = NULL, thr = 0.5, maxOrder = 2, reps = 10000, parallel = c("multicore","snow","no"), ncpus = 1){
    output <- wrapper.FE( CC = CC, CE = CE, EE =EE, thr = thr, maxOrder = maxOrder, reps =reps , parallel =parallel , ncpus = ncpus)
    return(output)
}

