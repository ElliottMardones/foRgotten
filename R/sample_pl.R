#' @import poweRlaw
sample_pl<-function(data,indices){
  remuestra  <- data[indices]
  remuestra  <- remuestra
  m_pl       <- conpl$new(remuestra)
  est        <- estimate_xmin(m_pl, xmax=Inf)
  m_pl$setXmin(est)
  m_pl$pars  <- estimate_pars(m_pl)
  mediana    <- 2^(1/m_pl$pars[1]-1)*m_pl$xmin
  return( mediana )
}

