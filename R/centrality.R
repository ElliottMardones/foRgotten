#' centrality
#' @title Centrality For Complete and Chain Bipartite Graphs
#' @aliases centrality
#' @description
#' Performs the calculation of the median betweenness centrality, confidence intervals
#'  and the selected method for the calculation of the distribution of centralities with multiple
#'   key informants for complete graphs and chain bipartite graphs.
#' @param CC Three-dimensional matrix, where each submatrix along the z-axis is
#'           a square and reflective incidence matrix, or a list of data.frames
#'           containing square and reflective incidence matrices. Each matrix
#'           represents a complete graph.

#' @param CE Three-dimensional matrix, where each submatrix along the z-axis is a
#'           rectangular incidence matrix, or a list of data.frames containing
#'           rectangular incidence matrices. Each matrix represents a bipartite graph.
#'            By default CE = NULL.

#' @param EE Three-dimensional matrix, where each submatrix along the z-axis is a
#'           square and reflective incidence matrix, or a list of data.frames
#'           containing square and reflective incidence matrices. Each matrix
#'           represents a complete graph. By default EE = NULL.

#' @param model Bootstrap with one of the following statistics: "conpl","conlnorm","median".
#'              By default Model = "median".

#' @param reps The number of bootstrap replicas. By default reps = 10,000.
#'
#' @param conf.level Real: Indicates the confidence levels of the required intervals. By default conf = 0.95.

#' @param parallel The type of parallel operation to use (if applicable). The options are "multicore", "snow" and "no". By default parallel = "no".

#' @param ncpus Integer: Number of processes that will be used in the parallel implementation.

#' @details The function implements "boot" from the boot package to obtain the confidence intervals and the p-value.
#'
#'The function contemplates two modalities, the first is focused on complete graphs and the second for chained bipartite graphs.
#'
#'If you use the full graph mode, make sure to keep the default values of the CE and EE parameters.
#'
#'The model parameter makes use of the PoweRlaw package. For "conpl" the median of a power distribution is calculated according to Newman, M. E. (2005), or "conlnorm" can be used according to Gillespie CS (2015). In the event that either of the two statistical methods fails, the error will be reported and the median centrality will be calculated.
#'
#'The parallel and ncpus options are not available on Windows operating systems.
#'
#' @return Returns a data.frame containing the following:
##'  \item{Median}{Calculated median.}
##'  \item{LCI}{Lower confidence interval.}
##'  \item{UCI}{Upper confidence interval.}
##'  \item{Method}{Statistical method used.}
#' @export
#' @references
#' Canty A, Ripley BD (2021). boot: Bootstrap R (S-Plus) Functions. R package version 1.3-28.
#' Csardi G, Nepusz T (2006). “The igraph software package for complex network research.” InterJournal, Complex Systems, 1695
#' Gillespie CS (2015). “Fitting Heavy Tailed Distributions: The poweRlaw Package.” Journal of Statistical Software, 64(2), 1–16.
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

