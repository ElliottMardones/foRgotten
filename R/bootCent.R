#' @import boot

bs_median_function <- function(data, statistic, R, parallel, ncpus){
  output <- tryCatch(
    bs_median <- boot(data = data, statistic = statistic, R = R, parallel = parallel, ncpus= ncpus), error = function(e) NULL
  )
  return(output)
}

conpl_function <- function(resultCent, R, conf,  parallel, ncpus){
  cent_table<-data.frame(Var=colnames(resultCent),Median=0,LCI=0,UCI=0, Method=0)
  for(j in seq_len(nrow(cent_table))){
    #browser()
    bs_median <- bs_median_function(data=resultCent[,j], statistic=sample_pl, R=R, parallel=parallel, ncpus=ncpus)

    if(is.null(bs_median)){
      bs_median <- boot(data = resultCent[,j], statistic = sample_median, R = R, parallel = parallel, ncpus= ncpus)
      cR <- colnames(resultCent)[j]
      if( bs_median$t0 == 0){
        warning("Variable ", cR ," has median = 0")
        cent_table[j,2] <- 0
        cent_table[j,3] <- 0
        cent_table[j,4] <- 0
        cent_table[j,5] <- "median"
      }
      else if( length(unique(resultCent[,j])) == 1){
        warning("All values in ", cR, "are equal")
        cent_table[j,2] <- unique(resultCent[,j])
        cent_table[j,3] <- unique(resultCent[,j])
        cent_table[j,4] <- unique(resultCent[,j])
        cent_table[j,5] <- "median"
      }else{
        cent_ci<-boot.ci(bs_median,conf = conf,type = "bca")
        cent_table[j,2:4]<-cbind(bs_median$t0,cent_ci$bca[4],cent_ci$bca[5])
        cent_table[j, 5]<- "median"
      }
    }else{
      cent_ci           <- boot.ci(bs_median,conf = conf,type = "bca")
      cent_table[j,2:4] <- cbind(bs_median$t0,cent_ci$bca[4],cent_ci$bca[5])
      cent_table[j, 5]  <- "conpl"
    }
  }
  return(cent_table)
}

conlnorm_function <- function(resultCent, R, conf,  parallel, ncpus){
  #browser()
  cent_table<-data.frame(Var=colnames(resultCent),Median=0,LCI=0,UCI=0, Method=0)#
  for(j in seq_len(nrow(cent_table))){
    bs_median <- bs_median_function(data=resultCent[,j], statistic=sample_ln, R=R, parallel=parallel, ncpus=ncpus)
    if(is.null(bs_median)){
      bs_median <- boot(data = resultCent[,j], statistic = sample_median, R = R, parallel = parallel, ncpus= ncpus)
      cR <- colnames(resultCent)[j]
      if( bs_median$t0 == 0){
        warning("Variable ", cR ," has median = 0")
        cent_table[j,2] <- 0
        cent_table[j,3] <- 0
        cent_table[j,4] <- 0
        cent_table[j,5] <- "median"
      }
      else if( length(unique(resultCent[,j])) == 1){
        warning("All values in ", cR, "are equal")
        cent_table[j,2] <- unique(resultCent[,j])
        cent_table[j,3] <- unique(resultCent[,j])
        cent_table[j,4] <- unique(resultCent[,j])
        cent_table[j,5] <- "median"
      }else{
        cent_ci<-boot.ci(bs_median,conf = conf,type = "bca")
        cent_table[j,2:4]<-cbind(bs_median$t0,cent_ci$bca[4],cent_ci$bca[5])
        cent_table[j, 5]<- "median"
      }
    }else{
      cent_ci           <- boot.ci(bs_median,conf = conf,type = "bca")
      cent_table[j,2:4] <- cbind(bs_median$t0,cent_ci$bca[4],cent_ci$bca[5])
      cent_table[j, 5]  <- "conlnorm"
    }
  }
  return(cent_table)
}

resultBoot_median <- function(resultCent, parallel, reps, ncpus, conf){
  cent_table<-data.frame(Var=colnames(resultCent),Median=0,LCI=0,UCI=0, Method = 0)#
  for(j in seq_len(nrow(cent_table))){

    bs_median <- boot(data = resultCent[,j], statistic = sample_median, R = reps, parallel = parallel, ncpus= ncpus)
    cR <- colnames(resultCent)[j]
    if( bs_median$t0 == 0){
      warning("Variable ", cR ," has median = 0")
      cent_table[j,2] <- 0
      cent_table[j,3] <- 0
      cent_table[j,4] <- 0
      cent_table[j,5] <- "median"
    }
    else if( length(unique(resultCent[,j])) == 1){
      warning("All values in ", cR, "are equal")
      cent_table[j,2] <- unique(resultCent[,j])
      cent_table[j,3] <- unique(resultCent[,j])
      cent_table[j,4] <- unique(resultCent[,j])
      cent_table[j,5] <- "median"
    }else{
      cent_ci<-boot.ci(bs_median,conf = conf,type = "bca")
      cent_table[j,2:4]<-cbind(bs_median$t0,cent_ci$bca[4],cent_ci$bca[5])
      cent_table[j, 5]<- "median"
    }
  }
  return(cent_table)
}

bootCent <- function(CC, CE, EE, model, reps, conf, parallel, ncpus){
  if( !is.null(CE) & !is.null(EE)){
    CC <- BTCgraphs_centrality(CC = CC, CE = CE, EE = EE)
  }
  if( missing(CC)){
    warning("Parameter CC is missing, its required.")
    return(NULL)
  }else{
    CC <- if( is.list(CC) == TRUE)  listo_to_Array3D(CC) else CC
    if( nrow(CC) != ncol(CC)){
      warning("Only for square matrix.")
      return(NULL)
    }
    output_resultIgraph <- resultIgraph(CC)
    model <- ifelse( length(model) != 1, "median", model )
    parallel <- ifelse( length(parallel) != 1, "no", parallel)

    if(model == "conpl"){
      pl <- conpl_function(resultCent=output_resultIgraph, parallel=parallel, R=reps, ncpus=ncpus, conf=conf)
      return(pl)
    }
    else if(model == "conlnorm"){
      ln <- conlnorm_function(resultCent=output_resultIgraph, parallel=parallel, R=reps, ncpus=ncpus, conf=conf)
      return(ln)
    }
    else if(model == "median"){
      median_resultBoot <- resultBoot_median(output_resultIgraph, parallel, reps, ncpus, conf)
      return(median_resultBoot)
    }
  }
}

