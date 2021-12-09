#' bootMargin
#' @title Significant Mean Causes and Effects For Complete and Chain Bipartite Graphs
#' @aliases bootMargin
#' @description
#' It performs the calculation of the mean incidence for each cause and each effect,
#'  confidence intervals and p-value with multiple key informants for complete graphs
#'   and chained bipartite graphs for multiple experts. The function allows eliminating
#'    causes and effects whose average incidence is not significant at the set thr.
#' @param CC Three-dimensional matrix, where each submatrix along the z-axis is a
#'  square and reflective incidence matrix, or a list of data.frames containing
#'  square and reflective incidence matrices. Each matrix represents a complete
#'  graph.
#' @param CE Three-dimensional matrix, where each submatrix along the z-axis is a
#'  rectangular incidence matrix, or a list of data.frames containing rectangular
#'   incidence matrices. Each matrix represents a bipartite graph. By default CE = NULL.
#'
#' @param EE Three-dimensional matrix, where each submatrix along the z-axis is a
#' square and reflective incidence matrix, or a list of data.frames containing square
#' and reflective incidence matrices. Each matrix represents a complete graph.
#' By default EE = NULL.
#'
#' @param thr Real between [0,1]: Defines the degree of truth for which the incidence
#' is considered significant. By default thr = 0.5.

#' @param reps The number of bootstrap replicas. By befault reps = 10.000.
#'
#' @param conf.level Real between [0,1]: Defines the confidence level.
#' By default conf.level = 0.95.
#'
#' @param delete Logical: If delete = TRUE, it deletes rows and columns whose incidences
#' are significantly less than the set thr. By default delete = FALSE.
#'
#' @param plot Logical: If plot = TRUE, creates a graph from the results obtained.
#'  By default plot = FALSE.
#'
#' @details
#' The function implements "boot.one.bca" from the wBoot package to obtain the confidence intervals and the p-value.

#' The function contemplates two modalities, the first is focused on complete graphs and the second for chained bipartite graphs.
#' If you use the full graph mode, make sure to keep the default values of the CE and EE parameters.

#' @return
#' The function returns a list with subsets of data.
#' The subset $byRow and $byCol contains the following values:
##'  \item{Var}{Variable name.}
##'  \item{Mean}{Calculated mean.}
##'  \item{LCI}{Lower Confidence Interval.}
##'  \item{UCI}{Upper Confidence Interval.}
##'  \item{p.value}{The calculated p-value.}
##' For delete = TRUE with complete graphs, the function returns $Data, the matrix entered
##'  in the CC parameter, but with the non-significant rows and columns removed.
#'
#'For delete = TRUE with chained bipartite graphs, the function returns $CC, $CE, $EE
#', the three-dimensional matrices entered in the parameters CC, CE and EE, but
#' eliminating the non-significant rows and columns.
#'
#'For plot = TRUE, the function returns the subset $plot, which contains the graph
#'generated from the data $byRow and $byCol. On the X axis there is "dependency"
#'associated with $byCol and on the Y axis "influence" associated with $byRow.
#'
#' @export
#'
#' @references
#' https://cran.r-project.org/web/packages/wBoot/index.html
#' @examples
#' # For complete graphs only the CC parameter is used.
#' # For instance:
#' bootMargin(CC = AA, thr = 0.5, reps = 500)
#' # For chain bipartite graphs the parameters CC, CE and EE are used.
#' # For instance:
#' bootMargin(CC = AA, CE = AB, EE = BB, thr = 0.5, reps = 500)
bootMargin <-function(CC, CE= NULL, EE= NULL,  thr = 0.5, reps=10000, conf.level = 0.95, delete=FALSE, plot = FALSE){

  output <- wrapper.BootMargin(CC = CC, CE = CE, EE = EE, thr=thr, reps=reps, conf.level =conf.level, delete=delete, plot=plot)

  return(output)
}

