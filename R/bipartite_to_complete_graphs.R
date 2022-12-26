validations_bc <- function(CC, CE, EE){
  A <- if( missing(CC))( warning("Parameter CC is missing, its required."))else(flag <- "Ok")
  B <- if( missing(CE))( warning("Parameter CE is missing, its required."))else(flag <- "Ok")
  C <- if( missing(EE))( warning("Parameter EE is missing, its required."))else(flag <- "Ok")
  myFlag <- c(A,B,C)
  if( length(myFlag) == 3){
    if( ncol(CC) == nrow(CE)){
      if( ncol(CE) == nrow(EE )){
        return(flag <- TRUE)
      }else{
        warning("The number of columns of CE is different from the number of rows of EE")
        return(flag <- FALSE)
      }
    }else{
      warning("The number of columns of CC is different from the number of rows of CE.")
      return(flag <- FALSE)
    }
  }else{
    return(flag <- FALSE)
  }
}

BTCgraphs_centrality <- function( CC, CE, EE){
  flag <- validations_bc( CC = CC, CE = CE, EE = EE)
  if(flag){
    CC <- if( is.list(CC) == TRUE)  listo_to_Array3D(CC) else CC
    CE <- if( is.list(CE) == TRUE)  listo_to_Array3D(CE) else CE
    EE <- if( is.list(EE) == TRUE)  listo_to_Array3D(EE) else EE
    nFilas <- nrow(CC) + nrow(EE)
    nColumnas <- ncol(CC) + ncol(EE)
    nexp <- dim(CC)[3]
    data_output <- array(rep(2,nFilas*nColumnas*nexp), dim = c(nFilas,nColumnas,nexp))
    for( i in seq_len(dim(CC)[3])){
      diag(CC[,,i]) <- 1
      diag(CE[,,i]) <- 1
      diag(EE[,,i]) <- 1
      CCs <- as.data.frame(CC[,,i])
      CEs <- as.data.frame(CE[,,i])
      EEs <- as.data.frame(EE[,,i])
      first <- cbind( CCs, CEs )
      m_output <- as.data.frame(matrix(2, ncol = ncol(CC), nrow = nrow(EE) ))
      colnames(m_output) <- colnames(CC)
      rownames(m_output) <- rownames(EE)
      second <- cbind( m_output, EEs)
      final_matrix <- rbind( first, second)
      data_output[,,i] <- as.matrix(final_matrix)
    }
    allRownames <- c(c(rownames(CC)), c(rownames(EE)))
    allColnames <- c(c(colnames(CC)), c(colnames(EE)))
    rownames(data_output) <- (allRownames)
    colnames(data_output) <- (allColnames)
    return(data_output)
  }else{
    return(NULL)
  }
}

BTCgraphs_bootMargin <- function( CC, CE, EE){
  flag <- validations_bc( CC = CC, CE = CE, EE = EE)
  if(flag){
    CC <- if( is.list(CC) == TRUE)  listo_to_Array3D(CC) else CC
    CE <- if( is.list(CE) == TRUE)  listo_to_Array3D(CE) else CE
    EE <- if( is.list(EE) == TRUE)  listo_to_Array3D(EE) else EE
    nFilas <- nrow(CC) + nrow(EE)
    nColumnas <- ncol(CC) + ncol(EE)
    nexp <- dim(CC)[3]
    data_output <- array(rep(NA,nFilas*nColumnas*nexp), dim = c(nFilas,nColumnas,nexp))
    for( i in seq_len(dim(CC)[3])){
      diag(CC[,,i]) <- NA
      diag(CE[,,i]) <- NA
      diag(EE[,,i]) <- NA
      CCs <- as.data.frame(CC[,,i])
      CEs <- as.data.frame(CE[,,i])
      EEs <- as.data.frame(EE[,,i])
      first <- cbind( CCs, CEs )
      m_output <- as.data.frame(matrix(NA, ncol = ncol(CC), nrow = nrow(EE) ))
      colnames(m_output) <- colnames(CC)
      rownames(m_output) <- rownames(EE)
      second <- cbind( m_output, EEs)
      final_matrix <- rbind( first, second)
      data_output[,,i] <- as.matrix(final_matrix)
    }
    allRownames <- c(c(rownames(CC)), c(rownames(EE)))
    allColnames <- c(c(colnames(CC)), c(colnames(EE)))
    rownames(data_output) <- (allRownames)
    colnames(data_output) <- (allColnames)
    return(data_output)
  }else{
    return(NULL)
  }
}

