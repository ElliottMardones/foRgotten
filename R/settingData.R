#' @import stats

toOriDest <- function(indirectEffects, order ){
  order                <- (order - 1)
  nExpertos            <- length(indirectEffects)
  indirectEffects_LIST <- list()
  for(i in seq_len(nExpertos)){
    lengthOfindirectEffects   <- length(indirectEffects[[i]])
    if(lengthOfindirectEffects < order){
      indirectEffects_LIST[[i]] <- data.frame(From="")
    }else{
      indirectEffects_LIST[[i]] <- indirectEffects[[i]][[order]]
    }
  }
  we_prior <- data.frame(Path="None", Count = 0 )
  for(i in seq_len(length(indirectEffects_LIST))){
    pass     <- data.frame(x = 0)
    we_prior <- cbind(we_prior, pass)
  }
  prior <- we_prior
  flag  <- we_prior
  #Separate the data that is not stored in the list of values to be able to add these values in the next iteration
  expertAccountant <- 0
  for(experto in seq_len(length(indirectEffects_LIST))){
    experto_por_nivel <- indirectEffects_LIST[[experto]]
    jump              <- order + 2
    if( ncol(experto_por_nivel)==1 ){
      expertAccountant <- expertAccountant + 1
      if(expertAccountant == length(indirectEffects_LIST)){
        col_names          <- list()
        str                <- sprintf("Expert_%d",seq_len(nExpertos))
        init               <- c("Path", "Count")
        col_names          <- rbind(col_names, append(init, str, after = 2))
        names(we_prior)    <- col_names
        we_prior           <- we_prior[-1,]
        rownames(we_prior) <- seq_len(nrow(we_prior))
        return(we_prior[order(we_prior$Count, decreasing=T),])
      }
    }
    else{
      temp2 <- apply(experto_por_nivel[,1:jump],1,function(index) paste(index,collapse = ' -> '))
      for(k in seq_len(length(temp2)) ){
        w <- which(we_prior$Path == temp2[k])
        if(length(w) != 0){
          we_prior$Count[w]      <- (we_prior$Count[w] + 1)
          we_prior[w, experto+2] <- experto_por_nivel[k,order+3]
        }
        else{
          prior$Path            <- temp2[k]
          prior$Count           <- (1)
          prior[ ,experto + 2 ] <- experto_por_nivel[k ,order + 3]
          we_prior              <- rbind(we_prior , prior)
          prior                 <- (flag)
        }
      }
    }
  }
  col_names          <- list()
  str                <- sprintf("Expert_%d",seq_len(nExpertos))
  init               <- c("Path", "Count")
  col_names          <- rbind(col_names, append(init, str, after = 2))
  names(we_prior)    <- col_names
  we_prior           <- we_prior[-1,]
  rownames(we_prior) <- seq_len(nrow(we_prior))
  return(we_prior[order(we_prior$Count, decreasing=T),])
}
########################################################################################################
########################################################################################################

settingNames.Through <- function(df_output){
  col_names        <- list()
  lg               <- length(colnames(df_output))-2 # i don't remember why less 2
  y                <- seq(lg)
  str              <- sprintf("Through_%d",y)
  init             <- c("From", "To")
  col_names        <- rbind(col_names, append(init, str, after = 1))
  names(df_output) <- col_names
  return(df_output)
}

strsplit_function <- function(newData){
  # Separate the elements with "->" to group the data in a data.frame
  Data      <- newData[1]
  df_output <- data.frame(Data="")
  for( i in seq_len(nrow(Data))){
    output   <- strsplit(Data[i,], " -> ")[[1]]
    for(j in seq_len(length(output))){
      df_output[i,j] <- output[j]
    }
  }
  df_output <- settingNames.Through(df_output)
  df_output <- cbind( df_output,newData[,-1])
  return(df_output)
}

########################################################################################################
########################################################################################################

# functiones for IE.r
putOrder <- function(cdata){
  if(length(cdata) !=0){
    cdatalenght <- length(cdata)
    changeValue <- seq(2, cdatalenght + 1)
    STR <- sprintf("Order_%d",changeValue)
    cdata <- setNames( cdata, STR)
    return(cdata)
  }else{
    return(cdata)
  }
}

putExpert <- function(cdata){
  cdatalenght <- length(cdata)
  changeValue <- seq(cdatalenght)
  STR <- sprintf("Expert_%d",changeValue)
  cdata <- setNames( cdata, STR)
  return(cdata)
}
putIE_order <- function(cdata){
  cdatalengh <- length(cdata)
  changeValue <- seq_len( cdatalengh )
  STR <- sprintf("Order_%d",changeValue)
  cdata <- setNames(cdata,STR)
  return(cdata[-1])
}
########################################################################################################
########################################################################################################


