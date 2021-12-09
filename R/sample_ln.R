#' @import poweRlaw
sample_ln<-function(data,indices){
  browser()
  remuestra  <- data[indices]
  remuestra  <- remuestra
  m_ln       <- conlnorm$new(remuestra)
  est        <- estimate_xmin(m_ln, xmax = Inf)
  m_ln$setXmin(est)
  m_ln$pars  <- estimate_pars(m_ln)
  return(exp(m_ln$pars[1]))
}

