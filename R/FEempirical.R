



tolist <- function(ll) {
    resultados <- list()
    for (x in seq_along(ll)) {
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

            if (length(uniq_pos[[z]]) > 2) {
                S_D <- c(S_D, sd(valores))
            } else {
                S_D <- c(S_D, sd(valores))
            }
        }

        if (!length(vec_pos) == 0) {
            df_resultado <- cbind(df[vec_pos, ], Count, Mean, SD = S_D)
            rownames(df_resultado) <- NULL
            vec_pos <- integer(0)

            resultados[[x]] <- df_resultado
        }
    }
    return(resultados)
}

# Toma los datos de FE_empirical y crea una lista de listas con los efectos olvidados por generacion.
compress_list <- function(arr){
    max_by_list <- max(sapply(arr, length))
    new_list <- list()
    for( i in seq_len(max_by_list)){
        data <- lapply(arr, function(x) if(length(x) >= i) x[[i]] else NULL)
        lista_filtrada <- Filter(function(x) !is.null(x), data)
        new_list[[i]] <- do.call(rbind, lista_filtrada)
    }
    return(new_list)
}


FE_empirical <- function(CC, CE , EE, reps , THR , maxOrder , CE_N ){
    new_list_test <- list()
    # Verificaciones segun sea los casos para los datos ingresados
    if(  is.null(EE) ){
        # Si EE es nulo debe calcula con CC y CE.
        for( r in seq_len(reps)){
            if(r%%100==0){
                print(paste("Replica: ",r))
            }
            # Definicion de las nuevas matrices CC y CE basadas en la empirica
            CC_empirica <- matrix( 0, nrow( CC ), ncol( CC ) )
            CE_empirica <- matrix( 0, nrow( CE ), ncol( CE ) )
            # Asignando nombre de fila y columna para CC_empirica
            rownames( CC_empirica ) <- rownames( CC )
            colnames( CC_empirica ) <- colnames( CC )
            # Asignando nombre de fila y columna para CE_empirica
            rownames( CE_empirica ) <- rownames( CE )
            colnames( CE_empirica ) <- colnames( CE )
            # Creando matrices empiricas
            # Primero para CC_empirica: TRABAJO FUTURO, PASAR ESTE CODIGO A RCPP
            for( i in seq_len( nrow( CC ))){
                for( j in seq_len( ncol( CC ))){
                    if( i != j){
                        CC_empirica[i,j] <- as.numeric(quantile( as.numeric(CC[i,j,]), runif(1,0,1), na.rm = TRUE))
                    }
                }
            }
            # Segundo para CE_empirica: TRABAJO FUTURO, PASAR ESTE CODIGO A RCPP
            for( i in seq_len( nrow( CE ))){
                for( j in seq_len( ncol( CE ))){
                    if( i != j){
                        CE_empirica[i,j] <- as.numeric(quantile( as.numeric(CE[i,j,]), runif(1,0,1), na.rm = TRUE))
                    }
                }
            }
            #--------------------------------------------------------------------------#
            # CALCULO DE EFECTOS OLVIDADOS
            # Diagonal igual a 1 para realiar el calculo de efectos olvidados
            # IMPORTANTE!!!!!!!!!!!!!!!!
            # Investigar que es mas costoso, crear la matriz con unos o hacer la diag() de 1.
            diag(CC_empirica) <- 1
            diag(CE_empirica) <- 1
            # aca llamo a la funcion recursiva y le paso los valores
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

            new_list_test[[r]] <- FE.recursive( CC=CC_empirica, CE=CE_empirica, EE=EE, THR = THR, maxOrder = maxOrder, CE_N = CE_empirica)

        }
    } else if( is.null(CC) ){
        for( r in seq_len(reps)){
            if(r%%100==0){
                print(paste("Replica: ",r))
            }
            # Definicion de las nuevas matrices CE y EE basadas en la empirica

            CE_empirica <- matrix( 0, nrow( CE ), ncol( CE ) )
            EE_empirica <- matrix( 0, nrow( EE ), ncol( EE ) )
            # Asignando nombre de fila y columna para CE_empirica
            rownames( CE_empirica ) <- rownames( CE )
            colnames( CE_empirica ) <- colnames( CE )
            # Asignando nombre de fila y columna para EE_empirica
            rownames( EE_empirica ) <- rownames( EE )
            colnames( EE_empirica ) <- colnames( EE )
            # Creando matrices empiricas
            # Primero para CC_empirica: TRABAJO FUTURO, PASAR ESTE CODIGO A RCPP
            for( i in seq_len( nrow( EE ))){
                for( j in seq_len( ncol( EE ))){
                    if( i != j){
                        EE_empirica[i,j] <- as.numeric(quantile( as.numeric(EE[i,j,]), runif(1,0,1), na.rm = TRUE))
                    }
                }
            }
            # Segundo para CE_empirica: TRABAJO FUTURO, PASAR ESTE CODIGO A RCPP
            for( i in seq_len( nrow( CE ))){
                for( j in seq_len( ncol( CE ))){
                    if( i != j){
                        CE_empirica[i,j] <- as.numeric(quantile( as.numeric(CE[i,j,]), runif(1,0,1), na.rm = TRUE))
                    }
                }
            }
            #browser()
            #--------------------------------------------------------------------------#
            # CALCULO DE EFECTOS OLVIDADOS
            # Diagonal igual a 1 para realiar el calculo de efectos olvidados
            diag(EE_empirica) <- 1
            diag(CE_empirica) <- 1
            # aca llamo a la funcion recursiva y le paso los valores
            # La lista que saca tengo que pasarla a una lista que contenga los valores de reps
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

            new_list_test[[r]] <- FE.recursive( CC=CC, CE=CE_empirica, EE=EE_empirica, THR = THR, maxOrder = maxOrder, CE_N = CE_empirica)
        }
    }else{
        # Para las tres matrices se usan las tres matrices
        for( r in seq_len(reps)){
            if(r%%100==0){
                print(paste("Replica: ",r))
            }
            # Definicion de las nuevas matrices CC y CE basadas en la empirica
            CC_empirica <- matrix( 0, nrow( CC ), ncol( CC ) )
            CE_empirica <- matrix( 0, nrow( CE ), ncol( CE ) )
            EE_empirica <- matrix( 0, nrow( EE ), ncol( EE ) )
            # Asignando nombre de fila y columna para CC_empirica
            rownames( CC_empirica ) <- rownames( CC )
            colnames( CC_empirica ) <- colnames( CC )
            # Asignando nombre de fila y columna para CE_empirica
            rownames( CE_empirica ) <- rownames( CE )
            colnames( CE_empirica ) <- colnames( CE )
            # Asignando nombre de fila y columna para EE_empirica
            rownames( EE_empirica ) <- rownames( EE )
            colnames( EE_empirica ) <- colnames( EE )
            # Creando matrices empiricas
            # Primero para CC_empirica: TRABAJO FUTURO, PASAR ESTE CODIGO A RCPP
            for( i in seq_len( nrow( CC ))){
                for( j in seq_len( ncol( CC ))){
                    if( i != j){
                        CC_empirica[i,j] <- as.numeric(quantile( as.numeric(CC[i,j,]), runif(1,0,1), na.rm = TRUE))
                    }
                }
            }
            # Segundo para CE_empirica: TRABAJO FUTURO, PASAR ESTE CODIGO A RCPP
            for( i in seq_len( nrow( CE ))){
                for( j in seq_len( ncol( CE ))){
                    if( i != j){
                        CE_empirica[i,j] <- as.numeric(quantile( as.numeric(CE[i,j,]), runif(1,0,1), na.rm = TRUE))
                    }
                }
            }
            # Primero para EE_empirica: TRABAJO FUTURO, PASAR ESTE CODIGO A RCPP
            for( i in seq_len( nrow( EE ))){
                for( j in seq_len( ncol( EE ))){
                    if( i != j){
                        EE_empirica[i,j] <- as.numeric(quantile( as.numeric(EE[i,j,]), runif(1,0,1), na.rm = TRUE))
                    }
                }
            }
            diag(CC_empirica) <- 1
            diag(CE_empirica) <- 1
            diag(EE_empirica) <- 1
            # aca llamo a la funcion recursiva y le paso los valores
            # La lista que saca tengo que pasarla a una lista que contenga los valores de reps
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

            new_list_test[[r]] <- FE.recursive( CC=CC_empirica, CE=CE_empirica, EE=EE_empirica, THR = THR, maxOrder = maxOrder, CE_N = CE_empirica)
        }
    }
    output <- tolist(compress_list(new_list_test))
    return( output )
}





