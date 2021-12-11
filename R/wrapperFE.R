#' @import stats
wrapper.FE <- function( CC, CE, EE, thr, maxOrder, reps, parallel, ncpus ){
    # agregar valicaciones
    # agregar validacion para parallel y ncpus
    parallel <- ifelse( length(parallel) != 1, "no", parallel)
    # agregar validaciones para las dimensiones de las matrices (m1: col = m2: row, m2:col = m3:row)
    # que pasa si una de las matrices de los laterales no esta presente???.
    if( is.null(CC)  & is.null(EE)){
        CE <- if( is.list(CE) == TRUE)  listo_to_Array3D(CE) else CE
        if( is.na(dim(CE)[3]) ){
            response <- call.FE.recursive(CC = CE, CE = CE, EE = NULL, THR = thr, maxOrder = maxOrder)
            return(putOrder(response))
        }
        list_of_experts <- vector(mode ="list" ,length = dim(CE)[3])
        for(i in seq_len(dim(CE)[3])){
            response <- call.FE.recursive(CC = CE[,,i], CE = CE[,,i], EE = NULL, THR = thr, maxOrder = maxOrder)
            if(length(response) == 0){
                warning("Expert number ", i," has no 2nd order or higher effects.")
            }else{
                list_of_experts[[i]] <- response
                list_of_experts[[i]] <- putOrder(list_of_experts[[i]])
            }
        }
        list_of_experts     <- putExpert(list_of_experts)
        res_strsplit        <- list()
        IE_list             <- list()
        globalCountMax      <- maxOrder
        for( j in 2:(globalCountMax)){
            experts_by_levels <- toOriDest(list_of_experts, order = j )
            if( nrow(experts_by_levels) != 0 ){
                res_strsplit[[j]]      <- strsplit_function(experts_by_levels)
                res_bootIE             <- bootIE(experts_by_levels, reps,parallel, ncpus)
                IE_list[[j]]           <- strsplit_function(res_bootIE)
            }
        }
        res_strsplit <- putIE_order(res_strsplit)
        IE_list      <- putIE_order(IE_list)
        return(list(boot= IE_list, byExperts = res_strsplit))
    }else if( is.null(EE) ){
        # derecha o cuadrada
        # 1) validacion de datos por izquierda
        CC <- if( is.list(CC) == TRUE)  listo_to_Array3D(CC) else CC
        CE <- if( is.list(CE) == TRUE)  listo_to_Array3D(CE) else CE
        # 2) resolver para cuando solo existe un experto
        if( is.na(dim(CE)[3]) ){
            response <- call.FE.recursive(CC = CC, CE = CE, EE = NULL, THR = thr, maxOrder = maxOrder)
            return(putOrder(response))
        }
        # 3) resolver para multiples expertos por izquierda
        list_of_experts <- vector(mode ="list" ,length = dim(CE)[3])
        for(i in seq_len(dim(CE)[3])){
            response <- call.FE.recursive(CC = CC[,,i], CE = CE[,,i], EE = NULL, THR = thr, maxOrder = maxOrder)
            if(length(response) == 0){
                warning("Expert number ", i," has no 2nd order or higher effects.")
            }else{
                list_of_experts[[i]] <- response
                list_of_experts[[i]] <- putOrder(list_of_experts[[i]])
            }
        }
        list_of_experts     <- putExpert(list_of_experts)
        res_strsplit        <- list()
        IE_list             <- list()
        globalCountMax      <- maxOrder
        for( j in 2:(globalCountMax)){
            experts_by_levels <- toOriDest(list_of_experts, order = j )
            if( nrow(experts_by_levels) != 0 ){
                res_strsplit[[j]]      <- strsplit_function(experts_by_levels)
                res_bootIE             <- bootIE(experts_by_levels, reps,parallel, ncpus)
                IE_list[[j]]           <- strsplit_function(res_bootIE)
            }
        }
        res_strsplit <- putIE_order(res_strsplit)
        IE_list      <- putIE_order(IE_list)
        return(list(boot= IE_list, byExperts = res_strsplit))
    }else if(is.null(CC)){
        # izquierda o cuadrada
        # 1) validacion de datos por derecha
        CE <- if( is.list(CE) == TRUE)  listo_to_Array3D(CE) else CE
        EE <- if( is.list(EE) == TRUE)  listo_to_Array3D(EE) else EE
        # 2) resolver para cuando solo existe un experto
        if( is.na(dim(CE)[3]) ){
            response <- call.FE.recursive(CC = NULL, CE = CE, EE = EE, THR = thr, maxOrder = maxOrder)
            #agregar el putOrder
            return(putOrder(response))
        }
        # 3) resolver para multiples expertos por derecha
        list_of_experts <- vector(mode ="list" ,length = dim(CE)[3])
        for(i in seq_len(dim(CE)[3])){
            response <- call.FE.recursive(CC = NULL, CE = CE[,,i], EE = EE[,,i], THR = thr, maxOrder = maxOrder)
            if(length(response) == 0){
                warning("Expert number ", i," has no 2nd order or higher effects.")
            }else{
                list_of_experts[[i]] <- response
                list_of_experts[[i]] <- putOrder(list_of_experts[[i]])
            }
        }
        list_of_experts     <- putExpert(list_of_experts)
        res_strsplit        <- list()
        IE_list             <- list()
        globalCountMax      <- maxOrder
        for( j in 2:(globalCountMax)){
            experts_by_levels <- toOriDest(list_of_experts, order = j )
            if( nrow(experts_by_levels) != 0 ){
                res_strsplit[[j]]      <- strsplit_function(experts_by_levels)
                res_bootIE             <- bootIE(experts_by_levels, reps,parallel, ncpus)
                IE_list[[j]]           <- strsplit_function(res_bootIE)
            }
        }
        res_strsplit <- putIE_order(res_strsplit)
        IE_list      <- putIE_order(IE_list)
        return(list(boot= IE_list, byExperts = res_strsplit))

    }else{
        # efectos conjugados
        # 1) validacion de las tres matrices
        CC <- if( is.list(CC) == TRUE)  listo_to_Array3D(CC) else CC
        CE <- if( is.list(CE) == TRUE)  listo_to_Array3D(CE) else CE
        EE <- if( is.list(EE) == TRUE)  listo_to_Array3D(EE) else EE
        # 2) resolver para cuando solo existe un experto
        if( is.na(dim(CC)[3]) & is.na(dim(CE)[3]) & is.na(dim(EE)[3])){
            response <- call.FE.recursive(CC = CC, CE = CE, EE = EE, THR = thr, maxOrder = maxOrder)
            return(putOrder(response))
        }
        # 3) resolver para multiples expertos (efectos conjugados)
        list_of_experts <- vector(mode ="list" ,length = dim(CC)[3])
        for(i in seq_len(dim(CE)[3])){
            response <- call.FE.recursive(CC = CC[,,i], CE = CE[,,i], EE = EE[,,i], THR = thr, maxOrder = maxOrder)
            if( length(response) == 0){
                warning("Expert number ", i," has no 2nd maxOrder or higher effects.")
            }else{
                list_of_experts[[i]] <- response
                list_of_experts[[i]] <- putOrder(list_of_experts[[i]])
            }
        }
        # putExperts: Establece el numero de experto asociado en la lista
        #browser()
        list_of_experts   <- putExpert(list_of_experts)
        res_strsplit      <- list()
        IE_list           <- list()
        globalCountMax    <- maxOrder
        for( j in 2:(globalCountMax)){
            experts_by_levels <- toOriDest(list_of_experts, order= j )
            if( nrow(experts_by_levels) != 0){
                res_strsplit[[j]]      <- strsplit_function(experts_by_levels)
                res_bootIE             <- bootIE(experts_by_levels, reps,parallel, ncpus)
                IE_list[[j]]           <- strsplit_function(res_bootIE)
            }
        }
        # putIE_order: Establece el orden en la lista por experto
        res_strsplit      <- putIE_order(res_strsplit)
        IE_list           <- putIE_order(IE_list)
        return(list( boot= IE_list, byExperts = res_strsplit))
    }
}
