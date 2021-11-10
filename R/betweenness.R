#' @importFrom igraph graph.adjacency
#' @importFrom igraph betweenness
#' @importFrom igraph delete.edges
#' @importFrom igraph E
resultIgraph <- function(data){
  nRow                 <- dim(data)[1]
  nCol                 <- dim(data)[2]
  experts              <- dim(data)[3]
  resultCent           <- matrix(nrow = experts, ncol = nRow)
  colnames(resultCent) <- colnames(data[,,1])
  for( i in seq_len(experts)){
    distance        <- (1 - data[,,i])
    grafo           <- igraph::graph.adjacency(distance, weighted = T, mode = "directed")
    grafo           <- delete.edges(graph = grafo, which(E(grafo)$weight < 0  ))
    cent            <- igraph::betweenness(grafo, directed = T)
    resultCent[i, ] <- cent
  }
  return(resultCent)
}
