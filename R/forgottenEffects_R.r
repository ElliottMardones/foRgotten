#' @import Rcpp

########################################################################################################
########################################################################################################
# ofuscando la var .GlobalEnv NO aparece la nota.
ofuss <- .GlobalEnv
assign_global <- function( xVal, valVal){
  assign(xVal, valVal, envir = ofuss)
}

rightHandPath <- function(data_set, original_matrix){
  lengthDataSet    <- length(data_set)
  nextGeneration   <- 0
  for(experts in seq_len(lengthDataSet)) {
    nextGeneration  <- (experts + 1)
    newDataList     <- list()
    if( nextGeneration <= lengthDataSet){
      for( nRows in seq_len(nrow(data_set[[experts]]))){
        for( nRowsNextG in seq_len(nrow(data_set[[nextGeneration]]))){
          origin             <-data_set[[experts]][nRows,]
          destination        <- data_set[[nextGeneration]][nRowsNextG,]
          originFrom         <- origin$From
          destinationFrom    <- destination$From
          originTo           <- origin$To
          destinationTo      <- destination$To
          destinationThrough <- destination$Through
          lengthOrigin       <- length(origin)
          originThrough      <- origin[, -lengthOrigin]
          lengthOrigin       <- length(originThrough)
          originThroughValue <- originThrough[[lengthOrigin-1]] #posiblemente borrar
          valueInMatrix      <- original_matrix[ destinationThrough, destinationTo]
          if( (originFrom == destinationFrom ) & (destinationThrough==originTo ) & (valueInMatrix != 0)){
            data_setActuales  <- origin[, -(length(origin))]
            data_setFinal     <- destination[, -(1:2)]
            newDataList       <- rbind(newDataList,(as.data.frame( append(data_setActuales, (data_setFinal) ))))
          }
        }
      }
      columnNames                <- list()
      lengthColumnNames          <- (length(colnames(newDataList)) -3)
      str                        <- sprintf("Through_%d",seq(lengthColumnNames))
      standardFormat             <- c("From", "To", "Mu")
      columnNames                <- rbind(columnNames, append(standardFormat, str, after = 1))
      names(newDataList)         <- columnNames
      data_set[[nextGeneration]] <- newDataList
    }
  }
  return(data_set)
}
########################################################################################################
########################################################################################################
right.recursive.ForgottenEfects <- function(AB, BB, secondGeneration, THR, order){
  counter_2_right    <- (counter_2_right + 1)
  assign_global("counter_2_right", counter_2_right)
  valueOverThreshold <- which( secondGeneration > THR+(1e-15))
  if( length( valueOverThreshold ) == 0  ){
    return(NULL)
  }else{
    if(counter_2_right >= (order+1)){
      dataOutput <- rev( dataList )
      return(dataOutput)
    }
    currentOrder     <- AB
    BB<- data.matrix(BB, rownames.force = NA)
    nextOrder        <- maxminRcpp(currentOrder, BB)
    secondGeneration <- (nextOrder - currentOrder)
    right.recursive.ForgottenEfects(nextOrder, BB, secondGeneration, THR, order )
    counter_1_right  <- (counter_1_right + 1)
    assign_global("counter_1_right", counter_1_right)
    datos_arr.ind    <- which(secondGeneration > THR+(1e-15), arr.ind = T)
    dataList[[counter_1_right]] <- feRcpp(datos_arr.ind, currentOrder, BB, secondGeneration)
    assign_global("dataList", dataList)
  }
  dataOutput <- rev(dataList[-1])
  return(dataOutput)
}
wrapper.right.FE <- function(AB, BB, THR, order=2){
  dataList        <- list()
  assign_global("dataList", dataList)
  counter_1_right <- 0
  assign_global("counter_1_right", counter_1_right)
  counter_2_right <- 0
  assign_global("counter_2_right", counter_2_right)
  AB              <- data.matrix(AB, rownames.force = TRUE)
  BB              <- data.matrix(BB, rownames.force = TRUE)
  output          <- right.recursive.ForgottenEfects(AB, BB, BB, THR, order)
  rm(dataList)
  return(rightHandPath(output, BB))
}
########################################################################################################
########################################################################################################


