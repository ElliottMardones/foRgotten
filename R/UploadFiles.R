#' loadFiles
#' @title loadFiles
#' @name loadFiles
#' @param directory directory
#' @param sep sep
#' @param header header
#' @param row.names row.names
#' @param maxnorm maxnorm
#' @param minnorm minnorm
#' @param diagone diagone
#' @param NAvalue NAvalue
#'
#' @return return
#' @export
loadFiles <- function(directory, sep=",", header=T,
                         row.names=1, maxnorm=10, minnorm=0,
                         diagone=T, NAvalue=.5) {
    # La funcion carga los archivos .csv de un directorio dado por el usuario.
    # PARAMETROS:
    ## directory: ruta para abrir los archivos
    ## sep: Metodo para separar los datos, por defecto es ","
    ## header: header = T toma la primera fila como nombres de columna
    ## row.names = 1: Toma la primera fila como nombres de fila
    ## maxnorm= 10: el valor indica el punto maximo de los datos para normalizar
    ## minorm= 0: el valor indica el punto minimo de los datos para normalizar
    ## diagone = T: diagonal igual a 1
    ## NAvalue= 0.5: cambia los NA values al valor 0.5
    file_list <- list.files(directory, pattern = "\\.csv$", full.names = TRUE)

    data <- lapply(file_list, function(csv) {
        thiscsv <- utils::read.table(csv,sep=sep,row.names=row.names,header=header,encoding = "UTF-8")
        thiscsv <- (thiscsv-minnorm)/(maxnorm-minnorm)
        if(diagone==T){
            diag(thiscsv)<-1
        }
        thiscsv[is.na(thiscsv)]<-NAvalue
        thiscsv
    })
    # Pasa la lista de datos a un arreglo de 3 dimensiones
    data <- listo_to_Array3D(data)
    return(data)
}
