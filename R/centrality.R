#' centrality
#' @title Centrality For Complete and Chain Bipartite Graphs
#' @aliases centrality
#' @description
#' The centrality() function calculates the median betweenness centrality, confidence intervals,
#' and the selected method for calculating the centrality distribution for complete and chained
#'  bipartite graphs using multiple key informants.
#'
#' @param CC It allows for entering a three-dimensional incidence array, with each submatrix along
#' the z-axis being a square incidence matrix. By default, CC = NULL.

#' @param CE  It allows for entering a three-dimensional incidence array, with each submatrix
#' along the z-axis being a square incidence matrix (for complete graphs) or a rectangular matrix
#' (for chained bipartite graphs).

#' @param EE It allows for entering a three-dimensional incidence array, with each submatrix
#' along the z-axis being a square incidence matrix. By default, EE = NULL.

#' @param model Allows you to determine to which heavy-tailed distribution the entered variables correspond.

#' @param reps Defines the number of bootstrap replicates. By default, reps = 10000.
#'
#' @param conf.level Defines the confidence level. By default, conf.level = 0.95.

#' @param parallel Sets the type of parallel operation required. The options are “multicore”, “snow”, and “no”. By default, parallel = "no".

#' @param ncpus Defines the number of cores to use. By default, ncpus = 1.
#' @details
#' The parallel and ncpus options are not available on Windows operating systems.
#'

#'
#' @return Returns a data.frame containing the following:
##'  \item{Var}{Name of the variable.}
##'  \item{Median}{Median calculated.}
##'  \item{LCI}{Lower Confidence Interval.}
##'  \item{UCI}{Upper Confidence Interval.}
##'  \item{Method}{Statistical method used associated with the model parameter.}
#' @export
#' @references
#' Canty A, Ripley BD (2021). boot: Bootstrap R (S-Plus) Functions. R package version 1.3-28.
#'
#' Csardi G, Nepusz T (2006). "The igraph software package for complex network research." InterJournal, Complex Systems, 1695.
#'
#' Gillespie CS (2015). "Fitting Heavy Tailed Distributions: The poweRlaw Package." Journal of Statistical Software, 64(2), 1-16.
#'
#' Newman, M. E. (2005). Power laws, Pareto distributions and Zipf's law. Contemporary physics, 46(5), 323-351.
#'
#' @examples
#' # For complete graphs only the CC parameter is used.
#' # For instance:
#' centrality( CE = CC, model = "median", reps = 100, parallel = "no", ncpus = 1)
#' # For chain bipartite graphs the parameters CC, CE and EE are used.
#' # For instance:
#' centrality( CC = CC, CE = CE, EE= EE, model = "median", reps = 100)
centrality <- function(CC = NULL, CE = NULL, EE = NULL, model = c("conpl", "median") , reps = 10000, conf.level = 0.95, parallel=c("multicore","snow","no") , ncpus = 1){

    output <- bootCent( CC = CC, CE = CE, EE = EE, model = model, reps =reps, conf.level = conf.level, parallel = parallel, ncpus = ncpus)

    return(output)
}

