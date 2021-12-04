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
