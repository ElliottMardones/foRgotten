#' @import Rcpp
ofuss <- .GlobalEnv
assign_global <- function( xVal, valVal){
    assign(xVal, valVal, envir = ofuss)
}
# elimina los data.frame NULL
delete_ <- function(data){
    v <- c()
    for( i in seq_len(length(data))){
        if( nrow(data[[i]]) == 0 ){
            v <- c(v,i)
        }
    }
    if( !is.null(v) ){
        data <- data[-v]
    }
    return(data)
}
# une las salidas de los efecos conjugados
unir <- function(Izq, Der){
    I <-Izq
    D <-Der
    Ilength <- length(Izq)
    Dlength <- length(Der)
    vMax    <- max(Ilength, Dlength)
    newList <- list()
    for( r in seq_len(vMax)){
        if( (length(I) >= r)  & (length(D) >= r )){
            newList[[r]] <- rbind( I[[r]], D[[r]])
        }else{
            if( length(I) >= r){
                newList[[r]] <- I[[r]]
            }else{
                if( length(D) >= r ){
                    newList[[r]] <- D[[r]]
                }
            }
        }
    }
    return(newList)
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
            }else{
                dataSet_left <- rev(dataSet_left[-1])
                dataSet_right <- rev(dataSet_right[-1])
                return(list(left=dataSet_left, right = dataSet_right))
            }
        }
        # poner aca un condicional para saber cuando es por izq o derecha
        if(  is.null(EE) ){
            print("IZQUIERDA")
            CE_n_x <- CE
            CE_n_1 <- maxmin_rcpp(CC, CE_n_x)
            CE_N   <- CE_n_1 - CE
            # CALL RECURSIVE
            FE.recursive(CC = CC, CE = CE_n_1, EE = NULL, THR = THR, maxOrder = maxOrder, CE_N =CE_N)
            counter_one <- counter_one + 1
            assign_global("counter_one", counter_one)
            threshold <- which( CE_N > THR+(1e-15),  arr.ind = T)
            dataList[[counter_one]] <- fe_left( threshold, CC, CE_n_x, CE_N)
            assign_global("dataList", dataList)
        }else if(  is.null(CC) ){
            print("DERECHA")
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
        }else{
            # ACA PARA LOS EFECTOS CONJUGADOS
            print("EFECTOS CONJUGADOS")
            CE_n_x <- CE
            CE_n_1 <- maxmin_rcpp(maxmin_rcpp(CC, CE_n_x), EE)
            CE_N   <- CE_n_1 - CE_n_x
            #########################################################
            # CALL RECURSIVE
            FE.recursive(CC, CE_n_1, EE, THR, maxOrder, CE_N)
            #########################################################
            counter_one <- counter_one + 1
            assign_global("counter_one", counter_one)
            #########################################################
            # Calculo de efectos olvidados en orden "counter_one +1"
            threshold    <- which(CE_N > THR+(1e-15), arr.ind = T)
            #dataLeft  <- fe_left(threshold, CC, CE_n_x, CE_n)
            data_from_Rcpp <- fe(threshold, CC, CE_n_x, EE, CE_N)

            dataLeft  <- data_from_Rcpp$left
            ###
            ###
            dataRight <- data_from_Rcpp$right
            #########################################################

            # Guarda los datos en las listas.
            dataSet_left[[counter_one]]  <- dataLeft
            dataSet_right[[counter_one]] <- dataRight
            #########################################################
            # Actualiazcion de variables globales.
            assign_global("dataSet_left", dataSet_left)
            assign_global("dataSet_right", dataSet_right)
        }
    }

    if( is.null(EE) ){
        output <- rev(dataList[-1])
        return(leftHandPath(output, CE))
    }else if(is.null(CC)){
        output <- rev(dataList[-1])
        return(rightHandPath(output, EE))
    }else{
        dataSet_left <- rev(dataSet_left[-1])
        dataSet_right <- rev(dataSet_right[-1])
        left <- delete_(dataSet_left)
        right <- delete_(dataSet_right)
        left <- leftHandPath(left,CE)
        right <- rightHandPath(right, EE)
        res <- unir(left,right)
        return(res)
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
