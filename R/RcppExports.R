# Generated by using Rcpp::compileAttributes() -> do not edit by hand
# Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

fe <- function(threshold, CC, CE, EE, M3) {
    .Call(`_foRgotten_fe`, threshold, CC, CE, EE, M3)
}

fe_left <- function(threshold, CC, CE, M3) {
    .Call(`_foRgotten_fe_left`, threshold, CC, CE, M3)
}

fe_right <- function(threshold, CE, EE, M3) {
    .Call(`_foRgotten_fe_right`, threshold, CE, EE, M3)
}

#' @useDynLib foRgotten, .registration=TRUE
maxmin_rcpp <- function(matrix_1, matrix_2) {
    .Call(`_foRgotten_maxmin_rcpp`, matrix_1, matrix_2)
}

Rcpp_directEffects <- function(M, rownamesData, colnamesData, thr, reps) {
    .Call(`_foRgotten_Rcpp_directEffects`, M, rownamesData, colnamesData, thr, reps)
}

