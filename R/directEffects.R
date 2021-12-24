
#' directEffects
#' @title Significant Direct Effects For Complete and Chain Bipartite Graphs
#' @aliases directEffects
#' @description Performs the calculation of the mean incidence, left one-sided confidence interval, and p-value with multiple key informants for complete graphs and chained bipartite graphs. The function allows assigning zeros to the edges whose mean incidences are not significant at the set p-value.

#'
#' @param CC Three-dimensional matrix, where each submatrix along the z-axis is a square and reflective incidence matrix, or a list of data.frames containing square and reflective incidence matrices. Each matrix represents a complete graph.
#' @param CE Three-dimensional matrix, where each submatrix along the z-axis is a rectangular incidence matrix, or a list of data.frames containing rectangular incidence matrices. Each matrix represents a bipartite graph. By default CE = NULL.
#' @param EE Three-dimensional matrix, where each submatrix along the z-axis is a square and reflective incidence matrix, or a list of data.frames containing square and reflective incidence matrices. Each matrix represents a complete graph. By default EE = NULL.

#' @param thr Real between [0,1]: Defines the degree of truth for which the incidence is considered significant. By default thr = 0.5.
#' @param conf.level Real between [0,1]: Defines the confidence level. By default conf.level = 0.95.

#' @param reps The number of bootstrap replicas. By default reps = 10,000.

#' @param delete Logical: If delete = TRUE, zeroes are assigned to edges whose incidences are significantly less than thr to the p-value set in conf.level. By default delete = FALSE.
#'
#' @details
#' The function implements "boot.one.bca" from the wBoot package to get the UCI and the p-value.
#'The function contemplates two modalities, the first is focused on complete graphs and the second for chain bipartite graphs.

#'If you use the full graph mode, make sure to keep the default values of the CE and EE parameters.

#'
#' @return
#' The function returns a list with subsets of data.
#' The $DirectEffects subset contains the following values:
##'  \item{From}{Origin of the incident.}
##'  \item{To}{Destination of the incident.}
##'  \item{Mean}{Average incidence.}
##'  \item{UCI}{Upper Confidence Interval of Incidence.}
##'  \item{p.value}{The calculated p-value.}
##'
#' For delete = TRUE with complete graphs, the function returns $Data, the three-dimensional
#'  matrix entered in the CC parameter, but assigning 0 to the non-significant edges.
#'
#'For delete = TRUE with chain bipartite graphs, the function returns $CC, $CE, $EE,
#'the three-dimensional matrices entered in the parameters CC, CE and EE, but assigning
#'0 to the non-significant edges.
#' @export
#' @references
#' https://cran.r-project.org/web/packages/wBoot/index.html
#'
#' @examples
#' #' # For complete graphs only the CC parameter is used.
#' # For instance:
#' directEffects(CE = CE, thr = 0.5, conf.level=0.95, reps = 100, delete = FALSE)
#' # For chain bipartite graphs the parameters CC, CE and EE are used.
#' # For instance:
#' directEffects(CC = CC, CE = CE, EE = EE, thr = 0.5, conf.level=0.95, reps = 100, delete = FALSE)
directEffects <- function(CC=NULL, CE =NULL, EE=NULL, thr=0.5, conf.level=0.95, reps=10000, delete=FALSE){
  if( !is.null(CC) & !is.null(EE)){
    output <- wrapper.de.rect(CC = CC, CE = CE , EE = EE, thr =thr, conf.level =conf.level, reps =reps, delete =delete)
    return(output)
  }else{
    output <- wrapper.de.sq(CE = CE, thr = thr, conf.level = conf.level, reps =reps, delete =delete)
    return(output)
  }
}

