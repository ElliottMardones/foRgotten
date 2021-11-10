sample_mean <- function(data, indices){
  sample <- data[indices]
  bar    <- mean(sample,na.rm = TRUE )
  return( (bar))
}

