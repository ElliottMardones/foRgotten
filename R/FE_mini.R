#' @title FE_mini
#' @aliases FE_mini
#' @name FE_mini
#'
#' @description The FE_mini() function calculates forgotten effects using a single
#' three-dimensional incidence array M. This function is a simplified version of
#' FE() designed for complete matrices where the cause-effect structure is already
#' represented in one matrix.
#'
#' @param M A square incidence matrix or a three-dimensional square incidence array.
#' Each submatrix along the z-axis represents the incidence matrix provided by one
#' key expert.
#'
#' @param mode Specify the mode for the FE_mini function. If the mode is set to
#' `"Per-Expert"`, the function calculates forgotten effects for each expert and
#' applies bootstrap. If the mode is set to `"Empirical"`, the function uses the
#' empirical procedure.
#'
#' @param thr Defines the degree of truth in which incidence is considered
#' significant within the range. By default, `thr = 0.5`.
#'
#' @param maxOrder Defines the limit of forgotten effects to calculate, if they
#' exist. By default, `maxOrder = 2`.
#'
#' @param reps Defines the number of bootstrap or empirical replicates. By default,
#' `reps = 10000`.
#'
#' @param parallel Sets the type of parallel operation required. The options are
#' `"multicore"`, `"snow"`, and `"no"`. By default, `parallel = "no"`.
#'
#' @param ncpus Defines the number of cores to use. By default, `ncpus = 1`.
#'
#' @details
#' This function is intended for data already arranged as a single square matrix
#' or three-dimensional square array `M`.
#'
#' For example, if `M` has dimensions 20 x 20 x 10, then each `M[, , k]`
#' represents the incidence matrix for expert `k`.
#'
#' Internally, `FE_mini()` uses the same forgotten effects calculation structure
#' as `FE()`, but without requiring the user to provide `CC`, `CE`, and `EE`
#' separately.
#'
#' The parallel and ncpus options are not available on Windows operating systems.
#'
#' @return The function returns a list with subsets of data.
#'
#' If `mode = "Per-Expert"`, the output contains:
#' \\itemize{
#'   \\item `boot`: List of data.frames with bootstrap results.
#'   \\item `byExperts`: List of data.frames with forgotten effects by expert.
#' }
#'
#' If `mode = "Empirical"`, the output contains a list of data.frames with the
#' empirical forgotten effects summarized by order.
#'
#' @export
#'
#' @references
#' Kaufmann, A., & Aluja, J. G. (1988). Modelos para la investigacion de efectos olvidados. Milladoiro.
#'
#' Canty A, Ripley BD (2021). boot: Bootstrap R (S-Plus) Functions. R package version 1.3-28.
#'
#' Csardi G, Nepusz T (2006). "The igraph software package for complex network research."
#' InterJournal, Complex Systems, 1695.
#'
#' Eddelbuettel D, Francois R (2011). "Rcpp: Seamless R and C++ Integration."
#' Journal of Statistical Software, 40(8), 1-18.
#'
#' Eddelbuettel D (2013). Seamless R and C++ Integration with Rcpp.
#' Springer, New York.
#'
#' Eddelbuettel D, Balamuta JJ (2018). "Extending R with C++: A Brief Introduction
#' to Rcpp." The American Statistician, 72(1), 28-36.
#'
#' @examples
#' FE_mini(M = M, mode = "Per-Expert", thr = 0.5, maxOrder = 2, reps = 100)
#'
#' FE_mini(M = M, mode = "Empirical", thr = 0.5, maxOrder = 2, reps = 100)
FE_mini <- function(M,
                    mode = c("Empirical", "Per-Expert"),
                    thr = 0.5,
                    maxOrder = 2,
                    reps = 10000,
                    parallel = c("multicore", "snow", "no"),
                    ncpus = 1) {

    mode <- match.arg(mode)
    parallel <- match.arg(parallel)

    output <- wrapper.FE_mini(
        M = M,
        mode = mode,
        thr = thr,
        maxOrder = maxOrder,
        reps = reps,
        parallel = parallel,
        ncpus = ncpus
    )

    return(output)
}


wrapper.FE_mini <- function(M, mode, thr, maxOrder, reps, parallel, ncpus) {

    M <- if (is.list(M) == TRUE) listo_to_Array3D(M) else M
    M <- dataVerification_mini(M)

    if (mode == "Empirical") {

        parallel <- NULL
        ncpus <- NULL

        output <- FE_empirical_mini(
            M = M,
            reps = reps,
            THR = thr,
            maxOrder = maxOrder
        )

        return(putOrder(output))

    } else if (mode == "Per-Expert") {

        output <- FE_bootstrap_mini(
            M = M,
            thr = thr,
            maxOrder = maxOrder,
            reps = reps,
            parallel = parallel,
            ncpus = ncpus
        )

        return(output)

    } else {

        stop("Use 'Empirical' or 'Per-Expert'.")
    }
}


dataVerification_mini <- function(M) {

    if (is.null(M)) {
        stop("M cannot be NULL.")
    }

    if (is.null(dim(M))) {
        stop("M must be a matrix or a three-dimensional array.")
    }

    if (!(length(dim(M)) %in% c(2, 3))) {
        stop("M must be a matrix or a three-dimensional array.")
    }

    if (dim(M)[1] != dim(M)[2]) {
        stop("M must be square: number of rows must be equal to number of columns.")
    }

    if (length(dim(M)) == 3 && dim(M)[3] < 1) {
        stop("The third dimension of M must contain at least one expert.")
    }

    dims <- dim(M)
    dn <- dimnames(M)

    if (is.null(dn)) {
        dn <- vector("list", length(dims))
    }

    if (is.null(dn[[1]])) {
        dn[[1]] <- paste0("V", seq_len(dims[1]))
    }

    if (is.null(dn[[2]])) {
        dn[[2]] <- paste0("V", seq_len(dims[2]))
    }

    if (length(dims) == 3 && is.null(dn[[3]])) {
        dn[[3]] <- paste0("Expert_", seq_len(dims[3]))
    }

    dimnames(M) <- dn

    return(M)
}


FE_bootstrap_mini <- function(M, thr, maxOrder, reps, parallel, ncpus) {

    parallel <- ifelse(length(parallel) != 1, "no", parallel)

    M <- if (is.list(M) == TRUE) listo_to_Array3D(M) else M
    M <- dataVerification_mini(M)

    # Caso con una sola matriz 2D.
    if (length(dim(M)) == 2) {

        response <- call.FE.recursive(
            CC = NULL,
            CE = M,
            EE = M,
            THR = thr,
            maxOrder = maxOrder
        )

        return(putOrder(response))
    }

    # Caso con varios expertos: M es un array 3D.
    list_of_experts <- vector(mode = "list", length = dim(M)[3])

    for (i in seq_len(dim(M)[3])) {

        response <- call.FE.recursive(
            CC = NULL,
            CE = M[, , i],
            EE = M[, , i],
            THR = thr,
            maxOrder = maxOrder
        )

        if (length(response) == 0) {

            warning("Expert number ", i, " has no 2nd order or higher effects.")

        } else {

            list_of_experts[[i]] <- response
            list_of_experts[[i]] <- putOrder(list_of_experts[[i]])
        }
    }

    list_of_experts <- putExpert(list_of_experts)

    res_strsplit <- list()
    IE_list <- list()
    globalCountMax <- maxOrder

    for (j in 2:globalCountMax) {

        experts_by_levels <- toOriDest(list_of_experts, order = j)

        if (nrow(experts_by_levels) != 0) {

            res_strsplit[[j]] <- strsplit_function(experts_by_levels)

            res_bootIE <- bootIE(
                experts_by_levels,
                reps,
                parallel,
                ncpus
            )

            IE_list[[j]] <- strsplit_function(res_bootIE)
        }
    }

    res_strsplit <- putIE_order(res_strsplit)
    IE_list <- putIE_order(IE_list)

    return(list(
        boot = IE_list,
        byExperts = res_strsplit
    ))
}


#' @importFrom stats quantile runif sd
FE_empirical_mini <- function(M, reps, THR, maxOrder) {

    M <- if (is.list(M) == TRUE) listo_to_Array3D(M) else M
    M <- dataVerification_mini(M)

    if (length(dim(M)) != 3) {
        stop("Empirical mode requires M to be a three-dimensional array.")
    }

    new_list_test <- list()

    for (r in seq_len(reps)) {

        if (r %% 100 == 0) {
            print(paste("Replica: ", r))
        }

        M_empirica <- matrix(
            0,
            nrow = dim(M)[1],
            ncol = dim(M)[2]
        )

        rownames(M_empirica) <- dimnames(M)[[1]]
        colnames(M_empirica) <- dimnames(M)[[2]]

        for (i in seq_len(dim(M)[1])) {
            for (j in seq_len(dim(M)[2])) {
                if (i != j) {
                    M_empirica[i, j] <- as.numeric(
                        quantile(
                            as.numeric(M[i, j, ]),
                            runif(1, 0, 1),
                            na.rm = TRUE
                        )
                    )
                }
            }
        }

        diag(M_empirica) <- 1

        new_list_test[[r]] <- call.FE.recursive(
            CC = NULL,
            CE = M_empirica,
            EE = M_empirica,
            THR = THR,
            maxOrder = maxOrder
        )
    }

    output <- tolist_mini(compress_list_mini(new_list_test))

    return(output)
}


compress_list_mini <- function(arr) {

    max_by_list <- max(sapply(arr, length))
    new_list <- list()

    for (i in seq_len(max_by_list)) {

        data <- lapply(arr, function(x) if (length(x) >= i) x[[i]] else NULL)
        lista_filtrada <- Filter(function(x) !is.null(x), data)

        if (length(lista_filtrada) != 0) {
            new_list[[i]] <- do.call(rbind, lista_filtrada)
        }
    }

    return(new_list)
}


tolist_mini <- function(ll) {

    resultados <- list()

    for (x in seq_along(ll)) {

        if (is.null(ll[[x]])) {
            next
        }

        df <- data.frame(ll[[x]][1:(2 + x)])
        filas <- do.call(paste, c(df, sep = ","))

        Count <- integer(0)
        Mean <- numeric(0)
        S_D <- numeric(0)
        vec_pos <- integer(0)

        df_resultado <- data.frame()

        list_pos <- lapply(filas, function(x) which(x == filas))
        uniq_pos <- unique(list_pos)

        for (z in seq_along(uniq_pos)) {

            vec_pos <- c(vec_pos, uniq_pos[[z]][1])
            valores <- ll[[x]][["Mu"]][uniq_pos[[z]]]

            Count <- c(Count, length(uniq_pos[[z]]))
            Mean <- c(Mean, sum(valores) / length(uniq_pos[[z]]))
            S_D <- c(S_D, sd(valores))
        }

        if (!length(vec_pos) == 0) {

            df_resultado <- cbind(df[vec_pos, ], Count, Mean, SD = S_D)
            rownames(df_resultado) <- NULL

            byDecreasing_true <- df_resultado[order(df_resultado$Count, decreasing = TRUE), ]
            rownames(byDecreasing_true) <- seq_len(nrow(byDecreasing_true))

            resultados[[x]] <- byDecreasing_true
        }
    }

    return(resultados)
}

