#' @import boot
#' @import stats
bootIE <- function(data, reps, parallel, ncpus){
  bootdata    <- data.frame(Path = character(),Count = numeric(), Mean = numeric(), LCI= numeric(), UCI=numeric(), SE=numeric())
  resultPath  <- data$Path
  resultCount <- data$Count
  for(i in seq_len(nrow(data))){
    ncolumns     <- ncol(data)
    expertValues <- as.numeric(data[i,3:ncolumns])
    expertValues <- round(expertValues,2) #lo cambie de 1 a 2
    EV           <- as.numeric(expertValues[which(expertValues != 0)])
    EV           <- unique(EV)
    expertValues <- as.numeric(expertValues[which(expertValues != 0)])
    if( length(EV) == 1 ){
      bootdata <- rbind( bootdata, data.frame(Path = resultPath[i],
                                              Count= resultCount[i],
                                              Mean = EV,
                                              LCI= NA,
                                              UCI= NA,
                                              SE= NA))
    }else{
      suppressWarnings({
      data_boot <- boot(data=expertValues, statistic = sample_mean, R = reps, parallel = parallel, ncpus= ncpus)
      sd.boot   <- sd(data_boot$t)
      cent_ci   <- boot.ci(data_boot, conf = 0.95,type = "bca")
      bootdata  <- rbind( bootdata, data.frame(Path = resultPath[i],
                                              Count= resultCount[i],
                                              Mean = data_boot$t0,
                                              LCI= cent_ci$bca[4],
                                              UCI= cent_ci$bca[5],
                                              SE= sd.boot)) })

    }
  }
  rownames(bootdata) <- seq_len(nrow(bootdata))
  return(bootdata)
}

