#' @import boot
#' @import poweRlaw

bs_median_function <- function(data, statistic, R, parallel, ncpus){
  output <- tryCatch(
    bs_median <- boot(data = data, statistic = statistic, R = R, parallel = parallel, ncpus= ncpus), error = function(e) NULL
  )
  return(output)
}

conpl_function <- function(resultCent, R, conf.level,  parallel, ncpus ){
  cent_table<-data.frame(Var=colnames(resultCent),Median=0,LCI=0,UCI=0, Method=0, pValue = 0.0)
  for(j in seq_len(nrow(cent_table))){
    col <- resultCent[ resultCent[,j]!=0 ,j]
    #
    assign_global("dist_rand", poweRlaw::dist_rand)
    assign_global("estimate_xmin", poweRlaw::estimate_xmin)
    #
    if( length(col) == 0){
        cent_table[j,2] <- 0
        cent_table[j,3] <- 0
        cent_table[j,4] <- 0
        cent_table[j,5] <- "median"
        cent_table[j, 6]  <- NA
    }else if(sd(col) == 0){
        cent_table[j,2] <- col[1]
        cent_table[j,3] <- col[1]
        cent_table[j,4] <- col[1]
        cent_table[j,5] <- "median"
        cent_table[j, 6]  <- NA
    }else{
        bs_median <- bs_median_function(data=col, statistic=sample_pl, R=R, parallel=parallel, ncpus=ncpus)
        if(is.null(bs_median)){
            bs_median <- boot(data = col, statistic = sample_median, R = R, parallel = parallel, ncpus= ncpus)
            #cR <- colnames(resultCent)[j]
            if( bs_median$t0 == 0){
                cent_table[j,2] <- 0
                cent_table[j,3] <- 0
                cent_table[j,4] <- 0
                cent_table[j,5] <- "median"
                cent_table[j, 6]  <- NA
            }
            else if( length(unique(resultCent[,j])) == 1){
                cent_table[j,2] <- unique(resultCent[,j])
                cent_table[j,3] <- unique(resultCent[,j])
                cent_table[j,4] <- unique(resultCent[,j])
                cent_table[j,5] <- "median"
                cent_table[j, 6]  <- NA
            }else{
                cent_ci<-boot.ci(bs_median,conf = conf.level,type = "bca")
                cent_table[j,2:4]<-cbind(bs_median$t0,cent_ci$bca[4],cent_ci$bca[5])
                cent_table[j, 5]<- "median"
                cent_table[j, 6]  <- NA
            }
        }else{
            cent_ci           <- boot.ci(bs_median,conf = conf.level ,type = "bca")
            cent_table[j,2:4] <- cbind(bs_median$t0,cent_ci$bca[4],cent_ci$bca[5])
            cent_table[j, 5]  <- "conpl"
            #
            m_pl <- conpl$new(col)
            est <- estimate_xmin(m_pl, xmax= max(col)*2)
            m_pl$setXmin(est)
            bsp <- poweRlaw::bootstrap_p(m_pl, no_of_sims=R, threads=ncpus)
            cent_table[j, 6]  <- bsp$p

            if( bsp$p <= (1 - conf.level )){
                cent_ci<-boot.ci(bs_median,conf = conf.level,type = "bca")
                cent_table[j,2:4]<-cbind(bs_median$t0,cent_ci$bca[4],cent_ci$bca[5])
                cent_table[j, 5]<- "median"
                cent_table[j, 6]  <- NA
            }
        }
    }
  }
  return(cent_table)
}



resultBoot_median <- function(resultCent, parallel, reps, ncpus, conf.level){
  cent_table<-data.frame(Var=colnames(resultCent),Median=0,LCI=0,UCI=0, Method = 0, pValue = 0)#
  for(j in seq_len(nrow(cent_table))){
    col <- resultCent[ resultCent[,j]!=0 ,j]
    if( length(col) == 0){
        cent_table[j,2] <- 0
        cent_table[j,3] <- 0
        cent_table[j,4] <- 0
        cent_table[j,5] <- "median length(col) == 0"
        cent_table[j, 6]  <- NA
        # 2 validar si sd(col) == 0 (rellenar con el primer valor y despues con 0)
    }else if(sd(col) == 0){
        cent_table[j,2] <- col[1]
        cent_table[j,3] <- col[1]
        cent_table[j,4] <- col[1]
        cent_table[j,5] <- "median sd(col) == 0"
        cent_table[j, 6]  <- NA
    }else{
        bs_median <- boot(data = col, statistic = sample_median, R = reps, parallel = parallel, ncpus= ncpus)
        if( bs_median$t0 == 0){
            cent_table[j,2] <- 0
            cent_table[j,3] <- 0
            cent_table[j,4] <- 0
            cent_table[j,5] <- "median"
            cent_table[j, 6]  <- NA
        }
        else if( length(unique(col)) == 1){
            cent_table[j,2] <- unique(col)
            cent_table[j,3] <- unique(col)
            cent_table[j,4] <- unique(col)
            cent_table[j,5] <- "median"
            cent_table[j, 6]  <- NA
        }else{
            cent_ci<-boot.ci(bs_median,conf = conf.level,type = "bca")
            cent_table[j,2:4]<-cbind(bs_median$t0,cent_ci$bca[4],cent_ci$bca[5])
            cent_table[j, 5]<- "median"
            cent_table[j, 6]  <- NA
        }
    }
  }
  return(cent_table)
}

bootCent <- function(CC, CE, EE, model, reps, conf.level, parallel, ncpus){
    ofuss <- .GlobalEnv
    assign_global <- function( xVal, valVal){
        assign(xVal, valVal, envir = ofuss)
    }
  if( !is.null(CE) & !is.null(EE)){
    CE <- BTCgraphs_centrality(CC = CC, CE = CE, EE = EE)
  }
  if( missing(CE)){
    warning("Parameter CC is missing, its required.")
    return(NULL)
  }else{
    CE <- if( is.list(CE) == TRUE)  listo_to_Array3D(CE) else CE
    if( nrow(CE) != ncol(CE)){
      warning("Only for square matrix.")
      return(NULL)
    }
    output_resultIgraph <- resultIgraph(CE)

    model <- ifelse( length(model) != 1, "median", model )
    parallel <- ifelse( length(parallel) != 1, "no", parallel)

    if(model == "conpl"){
      pl <- conpl_function(resultCent=output_resultIgraph, parallel=parallel, R=reps, ncpus=ncpus, conf.level=conf.level)
      rm("dist_rand", envir = ofuss)
      rm("estimate_xmin", envir = ofuss)
      rm(ofuss, envir = ofuss)
      return(pl)
    }
    else if(model == "median"){
      median_resultBoot <- resultBoot_median(output_resultIgraph, parallel, reps, ncpus, conf.level=conf.level)
      return(median_resultBoot)
    }
  }
}

