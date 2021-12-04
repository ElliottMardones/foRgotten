#' @import Rcpp


########################################################################################################
########################################################################################################
# assign global var
ofuss <- .GlobalEnv
assign_global <- function( xVal, valVal){
  assign(xVal, valVal, envir = ofuss)
}

leftHandPath <- function(data_set, original_matrix){

  lengthDataSet  <- length(data_set)
  nextGeneration <- 0
  for(experts in seq_len(lengthDataSet)) {
    nextGeneration <- (experts + 1 )
    newDataList    <- list()
    if( nextGeneration <= lengthDataSet){
      for( nRows in seq_len(nrow(data_set[[experts]]))){
        for( nRowsNextG in seq_len(nrow(data_set[[nextGeneration]]))){
          origin             <- data_set[[experts]][nRows,]
          destination        <- data_set[[nextGeneration]][nRowsNextG,]
          originFrom         <- origin$From
          destinationThrough <- destination$Through
          originTo           <- origin$To
          destinationTo      <- destination$To
          originTH           <- origin[,-1]
          originTH           <- originTH[[1]]
          valueInMatrix      <- original_matrix[originTH, destinationTo]
          if( (originTo == destinationTo ) &(destinationThrough==originFrom ) & (valueInMatrix != 0) ){
            currentSourceData        <- origin[, -(1)]
            length_currentSourceData <- length(currentSourceData)
            currentSourceData        <- currentSourceData[, -((length_currentSourceData-1):length_currentSourceData)]
            datosFinal               <- destination
            names(currentSourceData) <- "."
            newDataList              <- rbind(newDataList, data.frame(append( (datosFinal), (unlist(currentSourceData)), after = 2)))
          }
        }
      }
      columnNames                <- list()
      lengthColumnNames          <- (length(colnames(newDataList)) -3)
      str                        <- sprintf("Through_%d", seq(lengthColumnNames))
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
left.recursive.ForgottenEfects <- function(AA, AB, secondGeneration, THR, order){
  #browser()
  counter_2_left     <- counter_2_left + 1
  assign_global("counter_2_left", counter_2_left)
  valueOverThreshold <- which( secondGeneration > THR+(1e-15))
  if( length( valueOverThreshold ) == 0  ){
    return("NULL")
  }else{
    if(counter_2_left >= (order + 1)){
      dataOutput <- rev( dataList)
      return(dataOutput)
    }
    currentOrder     <- AB
    AB               <- data.matrix(AB, rownames.force = NA)
    AA               <- data.matrix(AA, rownames.force = NA)
    nextOrder        <- maxminRcpp(AA, currentOrder)
    secondGeneration <- (nextOrder - currentOrder)
    left.recursive.ForgottenEfects( AA, nextOrder, secondGeneration, THR, order )
    counter_1_left   <- (counter_1_left + 1)
    assign_global("counter_1_left", counter_1_left)
    datos_arr.ind    <- which(secondGeneration > THR+(1e-15), arr.ind = T)
    dataList[[counter_1_left]] <- feRcpp(datos_arr.ind, AA,currentOrder, secondGeneration)
    assign_global("dataList", dataList)
  }
  dataOutput <- rev( dataList[-1])
  return(dataOutput)
}
wrapper.left.FE <- function( AA, AB, THR, order=2){
  dataList       <-list()
  assign_global("dataList", dataList)
  counter_1_left <- 0
  assign_global("counter_1_left", counter_1_left)
  counter_2_left <- 0
  assign_global("counter_2_left", counter_2_left)
  AA             <- data.matrix(AA, rownames.force = TRUE)
  AB             <- data.matrix(AB, rownames.force = TRUE)
  output         <- left.recursive.ForgottenEfects(AA, AB, AA, THR, order)
  rm(dataList)
  return(leftHandPath(output, AB))
}
