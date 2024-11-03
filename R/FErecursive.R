#' @import Rcpp
ofuss <- .GlobalEnv
assign_global <- function( xVal, valVal){
    assign(xVal, valVal, envir = ofuss)
}


FE.recursive <- function( CC, CE, EE, THR, maxOrder, CE_N){
    counter_two    <- (counter_two + 1)
    assign_global("counter_two", counter_two)
    threshold <- which( CE_N > THR+(1e-15))
    if( length(threshold) == 0){
        return(data.frame(flag=NULL))
    }else{
        if( counter_two >= (maxOrder + 1)){
            if( is.null(CC) | is.null(EE)){
                output <- rev(dataList[-1])
                return(output)
            }
        }
        # USAR ESTE PARA EL CALCULO !!!
        if(  is.null(CC) ){
            #print("DERECHA")
            CE_n_x <- CE
            CE_n_1 <- maxmin_rcpp(CE_n_x, EE)
            CE_N   <- CE_n_1 - CE_n_x
            #browser()
            # CALL RECURSIVE
            FE.recursive(CC = NULL, CE = CE_n_1, EE = EE, THR = THR, maxOrder = maxOrder, CE_N = CE_N)
            counter_one <- counter_one + 1
            assign_global("counter_one", counter_one)
            threshold <- which( CE_N > THR+(1e-15), arr.ind = T)
            dataList[[counter_one]] <- fe_right( threshold, CE_n_x, EE, CE_N)
            assign_global("dataList", dataList)
        }
    }

    if(is.null(CC)){
        output <- rev(dataList[-1])
        return(rightHandPath(output, EE))
    }
}
call.FE.recursive <- function(CC = NULL, CE = NULL, EE = NULL, THR = 0.5, maxOrder = 2){
    dataList        <- list()
    assign_global("dataList", dataList)
    dataSet_left        <- list()
    dataSet_right       <- list()
    assign_global("dataSet_left", dataSet_left)
    assign_global("dataSet_right", dataSet_right)
    counter_one <- 0
    assign_global("counter_one", counter_one)
    counter_two <- 0
    assign_global("counter_two", counter_two)
    CC <- if( !is.null(CC))  data.matrix(CC, rownames.force = TRUE) else NULL
    CE <- if( !is.null(CE))  data.matrix(CE, rownames.force = TRUE) else NULL
    EE <- if( !is.null(EE))  data.matrix(EE, rownames.force = TRUE) else NULL

    output  <- FE.recursive( CC=CC, CE=CE, EE=EE, THR = THR, maxOrder = maxOrder, CE_N = CE)
    rm(dataList)
    return(output)
}
