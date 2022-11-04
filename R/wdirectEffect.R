
validations_de_rect <- function(CC, CE, EE){
  A <- if( missing(CC))( warning("Parameter CC is missing, its required."))else(flag <- "Ok")
  B <- if( missing(CE))( warning("Parameter CE is missing, its required."))else(flag <- "Ok")
  C <- if( missing(EE))( warning("Parameter EE is missing, its required."))else(flag <- "Ok")
  myFlag <- c(A,B,C)
  if( length(myFlag) == 3){
    if( ncol(CC) == nrow(CE)){
      if( ncol(CE) == nrow(EE )){
        return(flag <- TRUE)
      }else{
        warning("The number of columns of CE is different from the number of rows of EE")
        return(flag <- FALSE)
      }
    }else{
      warning("The number of columns of CC is different from the number of rows of CE.")
      return(flag <- FALSE)
    }
  }else{
    return(flag <- FALSE)
  }
}

wrapper.de.sq <- function(CE, thr, conf.level, reps, delete){
  if( missing(CE)){
    message("Parameter ce is missing, its required.")
    return(NULL)
  }else{
    if(is.list(CE)){
      CE <- listo_to_Array3D(CE)
    }
    bootCC <- data.frame(From = character(), To = character(), Mean = numeric(), UCI= numeric(), p.value = numeric())
    numdim  <- (dim(CE)[1] * dim(CE)[2] - dim(CE)[2] ) * dim(CE)[3]
    rownamesData <- rownames(CE[,,1])
    colnamesData <- colnames(CE[,,1])
    vector_Value  <- numeric()
    for(x in seq_len(dim(CE)[1]) ){
      for( y in seq_len(dim(CE)[2]) ){
        if( x != y){
          vector_Value <- CE[x,y,]
          valuesFromArrays <- (as.numeric(vector_Value))
          # change boot.one.bca by bootOneBCa
          Data.CI<- bootOneBCa(valuesFromArrays,mean,null.hyp = thr, alternative = "less",R=reps, conf.level = conf.level)#agrege conf.level a boot.one.bca
          pv <- ifelse( is.nan(Data.CI$p.value), NA, Data.CI$p.value)
          bootCC <- rbind( bootCC, data.frame(From = rownamesData[x],
                                              To = colnamesData[y],
                                              Mean = mean(valuesFromArrays),
                                              UCI= Data.CI$Confidence.limits[1],
                                              p.value = pv))

        }
      }
    }
    if( delete){
      conf.level <- 1 - conf.level
      borrar <-  which(bootCC$p.value < conf.level | ( bootCC$Mean < thr & is.na(bootCC$p.value)))
      temp <- bootCC[borrar, ]
      for( ii in seq_len(nrow(temp)) ){
        From <- temp[ii, 1]
        To <- temp[ii, 2]
        From <- which(rownamesData == From)
        To <- which(colnamesData == To)
        CE[From, To, ] <- 0
      }
      if(length(borrar > 0)){
        message("deleting data...")
        bootCC <- bootCC[-borrar, ]
        rownames(bootCC) <- seq_len(nrow(bootCC))
        return(list(Data=CE,DirectEffects=bootCC ))
      }else{
        message("There is no data to delete...")
        rownames(bootCC) <- seq_len(nrow(bootCC))
        return(list(Data=CE,DirectEffects=bootCC ))
      }

    }else{
      rownames(bootCC) <- seq_len(nrow(bootCC))
      return(list(DirectEffects=bootCC ))
    }
  }
}
wrapper.de.rect <- function( CC, CE, EE, thr, conf.level, reps, delete){
  flag <- validations_de_rect(CC = CC, CE = CE, EE=EE)
  if( flag == TRUE){
    CCdata <- wrapper.de.sq(CE= CC, reps= reps, conf.level =conf.level, thr=thr,delete =delete)
    CEdata <- wrapper.de.sq(CE= CE, reps= reps, conf.level =conf.level, thr=thr,delete =delete)
    EEdata <- wrapper.de.sq(CE= EE, reps= reps, conf.level =conf.level, thr=thr,delete =delete)
    DirectEffects_CC <- CCdata$DirectEffects
    DirectEffects_CE <- CEdata$DirectEffects
    DirectEffects_EE <- EEdata$DirectEffects
    output_AllDirecEffects <- rbind(DirectEffects_CC, DirectEffects_CE)
    output_AllDirecEffects <- rbind(output_AllDirecEffects,DirectEffects_EE)
    if(delete == TRUE){
      return(list(CC = CCdata$Data,
                  CE = CEdata$Data,
                  EE = EEdata$Data,
                  DirectEffects = output_AllDirecEffects))
    }else{
      return(list(DirectEffects = output_AllDirecEffects ))
    }
  }
}


