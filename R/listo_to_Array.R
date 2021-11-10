listo_to_Array3D <- function(data){
  dimData         <- dim(data[[1]])
  lengthData      <- length(data)
  temp            <- array(unlist(data), dim = c(dimData, lengthData))
  rownames(temp)  <- rownames(data[[1]])
  colnames(temp)  <- colnames(data[[1]])
  return(temp)
}

