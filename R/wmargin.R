#' @import boot
#' @import ggplot2
#' @import ggsci
#' @import ggrepel
plotBootMargin <-function(dataSet,axesLimits="", thr.cause, thr.effect){
  data <- list(Drivers =dataSet$byCause, Dependance =  dataSet$byEffect)
  data$Drivers$varname<- dataSet$byCause$Var
  data$Dependance$varname<-dataSet$byEffect$Var
  myVar <- factor(paste(data$Drivers$varname ), levels=data$Dependance$varname)
  p<-ggplot2::ggplot()+
    ggplot2::geom_hline(aes(yintercept=thr.cause),lty=2)+geom_vline(aes(xintercept=thr.effect),lty=2)+
    #geom_abline(lty=4)+
    ggplot2::geom_point(aes(x=data$Dependance$Mean,y=data$Drivers$Mean,col=myVar),size=2)+
    ggplot2::geom_linerange(aes(y=data$Drivers$Mean,xmin=data$Dependance$LCI,xmax=data$Dependance$UCI,
                                col=data$Drivers$varname),lwd=1.2,alpha=0.5)+
    ggplot2::geom_linerange(aes(x=data$Dependance$Mean,ymin=data$Drivers$LCI,ymax=data$Drivers$UCI,
                                col=data$Drivers$varname),lwd=1,alpha=0.5)+
    ggrepel::geom_text_repel(aes(x=data$Dependance$Mean,y=data$Drivers$Mean,
                                 label=data$Dependance$varname),alpha=1,col="black")+
    ggsci::scale_colour_ucscgb("Variables",palette = "default",alpha=1)+
    ggplot2::labs(x="Dependence",y="Influence")#+
  #theme_dark()+
  #theme(legend.position = "none")
  if(axesLimits=="auto"){
    p
  } else{
    p+xlim(0,1)+ylim(0,1)
  }
}
deconstructMatrix <- function(dataSet, AA, AB=NULL, BB=NULL){
  rownames_AA <- rownames(AA)
  rownames_AB <- rownames(AB)
  rownames_BB <- rownames(BB)
  my.rownames <- rownames(dataSet)
  onlyLetters <- gsub('\\d','', my.rownames)
  deleteThis <- length(which((onlyLetters) != onlyLetters[1]))
  row_AA <- my.rownames[1:(length(my.rownames)-deleteThis)]
  if(length(which( rownames_AA %in% row_AA)) != 0){
    if(length(row_AA) > 0){
      AA <- dataSet[row_AA,row_AA, , drop = FALSE]
    }
  }else{AA <- array()}
  if(length(my.rownames) > 1){
    row_BB <- my.rownames[which((onlyLetters) != onlyLetters[1])]
  }else{
    row_BB <- my.rownames
  }
  if(length(which( rownames_BB %in% row_BB)) != 0){
    if(length(row_BB) > 0){
      BB <- dataSet[row_BB,row_BB, , drop = FALSE]
    }
  }else{BB <- array()}
  if((length(which( rownames_BB %in% row_BB)) != 0) & (length(which( rownames_AA %in% row_AA)) != 0)){
    AB <- dataSet[row_AA, row_BB, , drop = FALSE]
  }else{AB <- array()}
  return(list(AA=AA, AB=AB, BB=BB))
}

wrapper.BootMargin<-function(CC, CE, EE, no.zeros,  thr.cause, thr.effect, reps, conf.level, delete, plot){
  if( !is.null(CC) & !is.null(EE)){
    CE <- BTCgraphs_bootMargin(CC = CC, CE = CE, EE = EE)
  }
  if( missing(CE)){
    message("Parameter CC is missing, its required.")
    return(NULL)
  }
  if( nrow(CE) == ncol(CE)){
    nn              <- nrow(CE)
    promFilas       <- data.frame(Var=rownames(CE[,,1]),Mean=0,LCI= 0,UCI=0,p.value=0)
    promColumnas    <- data.frame(Var=colnames(CE[,,1]),Mean=0,LCI= 0,UCI=0,p.value=0)
    #
    for( i in seq_len(nrow(CE[,,1]))){
        for( j in seq_len(ncol(CE[,,1]))){
            for( e in seq_len(dim(CE)[3])){
                if( i == j ){
                    CE[i,j,e]  <- NA
                }
            }
        }
    }
    #
    for(i in 1:nn){
      # nuevo parametro no.zeros
      #browser()
      if(no.zeros == TRUE){
          filasExp      <- (CE[i,,])[-i,]
          filasExp[filasExp==0] <- NA
          fila          <- rowMeans(filasExp, na.rm = TRUE)
          fila          <- na.omit(fila)
          #####################################
          # columna: take data by columns
          columnaExp      <- t(CE[,i,])[,-i]
          columna         <- rowMeans(columnaExp, na.rm = TRUE)
          # nuevo parametro no.zeros
          columna[columna==0] <- NA
          columna         <- na.omit(columna)
          if( !all(is.na(fila)) && !all(is.na(columna)) ){
              # change boot.one.bca by bootOneBCa
              fila.CI       <- bootOneBCa(fila, sample_mean, null.hyp = thr.cause ,
                                          alternative = "two.sided", R=reps, conf.level = conf.level)
              fila.Mean     <- fila.CI$Mean
              fila.LCI      <- fila.CI$Confidence.limits[1]
              fila.UCI      <- fila.CI$Confidence.limits[2]
              fila.p_value  <- fila.CI$p.value

              columna.CI      <- bootOneBCa(columna, sample_mean, null.hyp = thr.effect,
                                            alternative =  "two.sided", R=reps, conf.level = conf.level)
              columna.Mean    <- columna.CI$Mean
              columna.LCI     <- columna.CI$Confidence.limits[1]
              columna.UCI     <- columna.CI$Confidence.limits[2]
              columna.p_value <- columna.CI$p.value
              # unir las columnas
              promFilas[i,2:5]    <-cbind(fila.Mean, fila.LCI, fila.UCI, fila.p_value)
              promColumnas[i,2:5] <-cbind(columna.Mean ,columna.LCI, columna.UCI, columna.p_value)
          }
      }
      else{
          fila          <- rowMeans(filasExp, na.rm = TRUE)
          fila          <- na.omit(fila)
          # change boot.one.bca by bootOneBCa
          fila.CI       <- bootOneBCa(fila, sample_mean, null.hyp = thr.cause ,
                                      alternative = "two.sided", R=reps, conf.level = conf.level)
          fila.Mean     <- fila.CI$Mean
          fila.LCI      <- fila.CI$Confidence.limits[1]
          fila.UCI      <- fila.CI$Confidence.limits[2]
          fila.p_value  <- fila.CI$p.value
          #####################################
          # columna: take data by columns
          columnaExp      <- t(CE[,i,])[,-i]
          columna         <- rowMeans(columnaExp, na.rm = TRUE)
          # nuevo parametro no.zeros
          columna         <- na.omit(columna)
          columna.CI      <- bootOneBCa(columna, sample_mean, null.hyp = thr.effect,
                                        alternative =  "two.sided", R=reps, conf.level = conf.level)
          columna.Mean    <- columna.CI$Mean
          columna.LCI     <- columna.CI$Confidence.limits[1]
          columna.UCI     <- columna.CI$Confidence.limits[2]
          columna.p_value <- columna.CI$p.value
          # unir las columnas
          promFilas[i,2:5]    <-cbind(fila.Mean, fila.LCI, fila.UCI, fila.p_value)
          promColumnas[i,2:5] <-cbind(columna.Mean ,columna.LCI, columna.UCI, columna.p_value)
      }

    }
    if( delete ){
      delete_in_rows     <- which( promFilas$UCI < thr.cause | ( promFilas$Mean < thr.cause & is.nan( promFilas$p.value)))
      delete_in_cols     <- which( promColumnas$UCI < thr.effect | ( promColumnas$Mean < thr.effect & is.nan( promColumnas$p.value)))
      which_delete       <- delete_in_rows %in% delete_in_cols
      if( sum(which_delete) != 0 ){ promFilas    <- (promFilas[ -delete_in_rows[which_delete], ])}
      if( sum(which_delete) != 0 ){ promColumnas <- (promColumnas[ -delete_in_rows[which_delete], ])}
      if( length(promFilas) == 0 ){
        message("All data has been deleted...")
        return(NULL)
      }
      new_CC     <- CE[promFilas$Var, promColumnas$Var, , drop = FALSE]
      dataOutput <- list(Data=new_CC,byCause =  promFilas,byEffect = promColumnas)
      if(plot == TRUE){
        myPlot     <- plotBootMargin(dataSet=dataOutput, thr.cause=thr.cause, thr.effect=thr.effect)
        if( !is.null(CC) & !is.null(EE)){
          allMatrix <- deconstructMatrix(dataSet = new_CC, AA= CC, AB= CE, BB= EE)
          return(list(CC=allMatrix$AA, CE =allMatrix$AB, EE = allMatrix$BB, byCause =  promFilas, byEffect = promColumnas,plot = myPlot ))
        }
        dataOutput <- list(Data  = new_CC,
                           byCause = promFilas,
                           byEffect = promColumnas,
                           plot = myPlot )
        return(dataOutput)
      }else{
        if( !is.null(CC) & !is.null(EE)){
          allMatrix <- deconstructMatrix(dataSet = new_CC, AA= CC, AB= CE, BB= EE)
          return(list(CC=allMatrix$AA, CE =allMatrix$AB, EE = allMatrix$BB, byCause =  promFilas, byEffect = promColumnas))
        }
        return(list(Data=new_CC, byCause =  promFilas, byEffect = promColumnas))
      }
    }
    dataOutput <- list(byCause = promFilas,byEffect = promColumnas)
    if(plot == TRUE){
      dataOutput <- list(byCause = promFilas, byEffect = promColumnas)
      myPlot     <- plotBootMargin(dataSet=dataOutput, thr.cause=thr.cause, thr.effect=thr.effect)
      dataOutput <- list(byCause = promFilas, byEffect = promColumnas, plot = myPlot )
      return(dataOutput)
    }else{
      return(dataOutput)
    }
  }else{
    warning("Only for complete graphs")
  }
}

