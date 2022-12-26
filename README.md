
<!-- README.md is generated from README.Rmd. Please edit that file -->

# foRgotten

<!-- badges: start -->
<!-- badges: end -->

## Description

The foRgotten library extends the theory of forgotten effects with the
aggregation of multiple key informants for complete graphs and chain
bipartite graphs. Provides analysis tools for direct effects and
forgotten effects.

The package allows for:

-   Calculation of the average incidence by edges for direct effects.
-   Calculation of the average incidence per row and column for direct
    effects.
-   Calculation of the median betweenness centrality per node for direct
    effects.
-   Calculation of the forgotten effects.
-   Use of complete graphs and chain bipartite graphs.

## Authors

**Elliott Jamil Mardones Arias** School of Computer Science Universidad
Católica de Temuco Rudecindo Ortega 02351 Temuco, Chile
<elliott.mardones@uct.cl>

**Julio Rojas-Mora** Department of Computer Science Universidad Católica
de Temuco Rudecindo Ortega 02351 Temuco, Chile and Centro de Políticas
Públicas Universidad Católica de Temuco Temuco, Chile
<julio.rojas@uct.cl>

## Installation

You can install the stable version of foRgotten from CRAN with:

``` r
# install.packages(“foRgotten”)
```

and the development version from GitHub with:

``` r
#install.packages(“devtools”)
#devtools::install_github("ElliottMardones/foRgotten")
```

## Usage

``` r
library(foRgotten)
```

## 

## Functions

The package provides four functions:

``` r
?directEffects
#> starting httpd help server ... done
```

Computes the mean incidence, left one-sided confidence interval, and
p-value with multiple key informants for complete graphs and chained
bipartite graphs. For more details, see help (de.sq).

``` r
?bootMargin
```

Computes the mean incidence for each cause and each effect, confidence
intervals, and p-value with multiple key informants for complete graphs
and chain bipartite graphs. For more details, see help(bootMargin).

``` r
?centrality
```

Performs the computation of median betweenness centrality with multiple
key informants for complete graphs and chain bipartite graphs. For more
details, see help(centrality).

``` r
?FE
```

Performs the forgotten effects calculation proposed by Kaufman and
Gil-Aluja (1988) with multiple experts. The parameters allow you to
specify the significant degree of truth and the order of incidence that
is required to be calculated for chained bipartite graphs For more
details, see help(FE).

## DataSet

The library provides 3 three-dimensional incidence matrices which are
called `CC`, `CE` and `EE`. The data are those used in the study
“Application of the Forgotten Effects Theory For Assessing the Public
Policy on Air Pollution Of the Commune of Valdivia, Chile” developed by
Manna, E. M et al (2018).

The data consists of 16 incentives, 4 behaviors and 10 key informants,
where each of the key informants presented the data with a minimum and
maximum value for each incident. The description of the data can be seen
in Tables 1 and 2 of Manna, E. M et al (2018).

The book store presents the data with the average between the minimum
and maximum value for each incidence, A being the equivalent to
incentives and B to behaviors. For more details of the data you can
consult:

``` r
help(CC)
help(CE)
help(EE)
```

## Examples

### **directEffects()**

The `directEffects()` function calculates the mean incidence, left-sided
confidence interval, and p-value for complete graphs and chained
bipartite graphs using multiple key informants. This function uses the
bootstrap method with adjusted BCa and a left-sided hypothesis test
based on the t-test.

The `thr` parameter defines the degree of truth in which the incidence
is considered significant within the range \[0,1\], while `conf.level`
defines the confidence level, and `reps` specify the number of bootstrap
replicas. By default, `thr = 0.5`, `conf.level = 0.95` and
`reps = 10000`.

The `CE` parameter allows you to enter a three-dimensional incidence
array, where each submatrix along the z-axis is a square or rectangular
incidence matrix. To calculate with complete graphs the matrices must be
square. To compute with chained bipartite graphs the matrices must be
rectangular, and the parameters `CC` and `EE` must be used, which allows
entering three-dimensional incidence arrays where each submatrix along
the z-axis is a square and reflective incidence matrix.

Implementation example:

``` r
result <- directEffects(CE = CC, thr = 0.5, reps = 1000)
```

The function returns a list object with the subset of data
`$DirectEffects` that includes the following information:

-   From: Origin of the incident.
-   To: Destination of the incident.
-   Mean: Average incidence.
-   UCI: Upper Confidence Interval.
-   p.value: The calculated p-value.

In this case, the results correspond to 240 first-order incidences. The
first six values are:

``` r
head(result$DirectEffects)
#>   From To  Mean   UCI p.value
#> 1   I1 I2 0.525 0.650   0.601
#> 2   I1 I3 0.450 0.595   0.303
#> 3   I1 I4 0.525 0.665   0.618
#> 4   I1 I5 0.465 0.635   0.371
#> 5   I1 I6 0.645 0.815   0.869
#> 6   I1 I7 0.815 0.875   1.000
```

Any result containing a NA value in the UCI and p.value fields indicates
that all incidences are the same or that the value is unique. Therefore,
bootstrapping is not done.

The `delete` parameter allows you to assign zeros to edges whose
incidences are significantly less than `thr` at the p-value set in the
`conf.level` parameter. In addition, this allows you to remove
non-significant results from the `$DirectEffects` set.

For example, to remove mean incidences less than 0.5 or incidences with
a p-value less than 1- `conf.level`:

``` r
result <- directEffects(CE = CC, thr = 0.5, reps = 1000, delete = TRUE)
#> deleting data...
```

Significant direct effects decreased from 240 to 205 with
`delete = TRUE`.

Note: However, this does not guarantee that a non-significant
first-order variable will not generate second-order effects since the
data is obtained from its empirical distribution.

For `delete = TRUE`, the function returns `$Data`, the three-dimensional
incidence array entered in the `CE` parameter but assigning 0 to
non-significant edges.

#### For chain bipartite graphs

To calculate the significant direct effects of the incidence matrices
`CC`, `CE` and `EE`, which are described in DataSet, we make use of the
already described parameter `CE`. The `EE` parameter is equivalent to
the `CC` parameter. The `CC` parameter allows us to enter a
three-dimensional matrix, where each submatrix along the z-axis is a
square incidence matrix and reflective, or a list of data.frame
containing square and reflective incidence matrices. Each matrix
represents a bipartite graph.

For example, let `thr = 0.5` and `reps = 1000`, you get:

``` r
result <- directEffects(CC = CC, CE = CE, EE = EE, reps = 1000)
```

The results obtained correspond to 312 first-order incidents. Using the
`delete = TRUE` parameter, the number of first-order significant
occurrences was reduced to 271.

For `delete = TRUE`, the function returns `$CC`, `$CE`, and `$EE`, which
are the three-dimensional matrices entered in the parameters `CC`, `CE`,
and `EE`, but assigning 0 to the non-significant edges.

### bootMargin()

The `bootMargin()` function calculates the mean incidence of each cause
and each effect, confidence intervals, and p-value with multiple experts
for complete graphs and chain bipartite graphs.

The function contemplates two modalities, the first is focused on
complete graphs and the second for chain bipartite graphs.

#### **For complete graphs**

To calculate the average incidence of each cause and each effect of the
`CC` incidence matrix, which is described in DataSet, we use the `CE`
parameter, which allows us to enter a three-dimensional matrix, where
each sub-matrix along the z-axis is a rectangular incidence matrix or a
list of data.frame containing rectangular incidence matrices. The `CC`
and `EE` parameters are used to perform the calculation with chain
bipartite graphs, therefore it is necessary that these parameters are
not used.

To define the degree of truth in which the incidence is considered
significant, the parameter `thr` is used, which is defined between
`[0,1]`. By default `thr = 0.5`.

The `bootMargin()` uses the bootstrap method with BCa adjusted boot and
with a left one-sided hypothesis test based on the Z-test. The
`conf.level` parameter defines the confidence level and `reps` the
number of bootstrap replicas. By default `conf.level = 0.95` and
`reps = 10000`.

For example, let `thr = 0.6` and `reps = 1000` we get:

``` r
result <- bootMargin(CE = CC, thr.cause = 0.6,thr.effect =  0.6, reps = 1000)
```

The function returns a list object with the data subsets `$byCause` and
`$byEffect`, each of these subsets of data contains the following
values:

-   Var: Variable name
-   Mean: Calculated mean.
-   LCI: Lower Confidence Interval
-   ICU: Upper Confidence Interval
-   p.value: the calculated p-value.

The `bootMargin()` function allows you to analyze by node or by
variable. The results obtained are:

For `$byCause`

``` r
result$byCause
#>    Var      Mean       LCI       UCI p.value
#> 1   I1 0.5335803 0.4819491 0.5905583   0.046
#> 2   I2 0.6032916 0.5485472 0.6535833   0.870
#> 3   I3 0.4396010 0.3854243 0.4870380   0.000
#> 4   I4 0.4996394 0.4359759 0.5533593   0.000
#> 5   I5 0.5484482 0.4882185 0.6042259   0.114
#> 6   I6 0.5601163 0.4874352 0.6224500   0.238
#> 7   I7 0.5372233 0.4866861 0.5870065   0.054
#> 8   I8 0.5472762 0.4783417 0.6156028   0.134
#> 9   I9 0.4696000 0.4138139 0.5232583   0.000
#> 10 I10 0.4931266 0.4180299 0.5541674   0.008
#> 11 I11 0.6100906 0.5617722 0.6570806   0.698
#> 12 I12 0.4689011 0.4190607 0.5136712   0.000
#> 13 I13 0.5551019 0.4769750 0.6363417   0.360
#> 14 I14 0.3259485 0.2832515 0.3644821   0.000
#> 15 I15 0.5019381 0.4590488 0.5481508   0.004
#> 16 I16 0.5349291 0.4846662 0.5863442   0.042
```

For `$byEffect`

``` r
result$byEffect
#>    Var      Mean       LCI       UCI p.value
#> 1   I1 0.5043778 0.3852000 0.6131126   0.142
#> 2   I2 0.5617796 0.4460705 0.6713583   0.526
#> 3   I3 0.4432460 0.3424846 0.5491525   0.038
#> 4   I4 0.4896544 0.3657877 0.6110155   0.132
#> 5   I5 0.4843547 0.3859604 0.5735321   0.024
#> 6   I6 0.6101958 0.4677119 0.7133935   0.942
#> 7   I7 0.5681769 0.4643301 0.6688282   0.638
#> 8   I8 0.5907612 0.5289324 0.6571086   0.742
#> 9   I9 0.4625977 0.3564726 0.5663988   0.070
#> 10 I10 0.5024064 0.4038971 0.6051851   0.116
#> 11 I11 0.5952512 0.4499701 0.7230543   0.914
#> 12 I12 0.4763135 0.3577796 0.6009649   0.072
#> 13 I13 0.5675811 0.4969071 0.6416667   0.468
#> 14 I14 0.3438947 0.2284743 0.4655359   0.000
#> 15 I15 0.4804747 0.3602301 0.5958821   0.084
#> 16 I16 0.6260739 0.5398048 0.7071607   0.686
```

The function allows eliminating causes and effects whose average
incidence is not significant at the set `thr` parameter. For example,
for `delete = TRUE`, the number of significant variables decreased.

``` r
result <- bootMargin(CE = CC, thr.cause = 0.6,thr.effect =  0.6, reps = 1000, delete = TRUE)
```

For `$byCause`

``` r
result$byCause
#>    Var      Mean       LCI       UCI p.value
#> 1   I1 0.5339872 0.4829620 0.5886694   0.048
#> 2   I2 0.6022300 0.5459917 0.6573389   0.844
#> 4   I4 0.5002067 0.4413806 0.5509630   0.000
#> 5   I5 0.5481870 0.4892167 0.6048556   0.122
#> 6   I6 0.5583467 0.4915491 0.6205667   0.238
#> 7   I7 0.5377710 0.4902296 0.5896731   0.044
#> 8   I8 0.5470409 0.4747037 0.6139528   0.178
#> 10 I10 0.4918836 0.4198965 0.5584222   0.002
#> 11 I11 0.6088033 0.5635556 0.6580741   0.624
#> 13 I13 0.5574562 0.4706639 0.6353639   0.368
#> 16 I16 0.5355015 0.4830176 0.5887944   0.054
```

For `$byEffect`

``` r
result$byEffect
#>    Var      Mean       LCI       UCI p.value
#> 1   I1 0.5044226 0.3903323 0.6146494   0.124
#> 2   I2 0.5615336 0.4510487 0.6713417   0.512
#> 4   I4 0.4889855 0.3689697 0.6113712   0.150
#> 5   I5 0.4813164 0.3846136 0.5708542   0.036
#> 6   I6 0.6111918 0.4728918 0.7206353   0.970
#> 7   I7 0.5683192 0.4625917 0.6713808   0.616
#> 8   I8 0.5886028 0.5231446 0.6573919   0.800
#> 10 I10 0.5064445 0.4135212 0.6167446   0.094
#> 11 I11 0.5946274 0.4675299 0.7265750   0.944
#> 13 I13 0.5683173 0.4939808 0.6416821   0.442
#> 16 I16 0.6230741 0.5455081 0.7101198   0.594
```

For `delete = TRUE`, the function returns`$Data`, the matrix entered in
the `CC`parameter, but with the non-significant rows and columns
removed.

For `plot = TRUE`, the function returns `$plot`, which contains the
graph generated from the subsets `$byCause` and `$byEffect`. On the
x-axis are the “Dependence” associated with `$byEffect` and on the
y-axis the “Influence” is associated with `$byCause`.

``` r
result <- bootMargin(CE = CC, thr.cause = 0.6,thr.effect =  0.6, reps = 1000, delete = TRUE, plot = TRUE)
result$plot
```

<img src="man/figures/README-unnamed-chunk-17-1.png" width="100%" />

#### **For chain bipartite graphs**

To calculate the average incidence of each cause and each effect of the
incidence matrices `CC`, `CE`and `EE`, which are described in DataSet,
we make use of parameter `CC`. The `EE`parameter is equivalent to the
`CC`parameter. The `CC` parameter allows us to enter a three-dimensional
matrix, where each submatrix along the z-axis is a square incidence
matrix and reflective, or a list of data.frame containing square and
reflective incidence matrices. Each matrix represents a bipartite graph.

For example, let `thr = 0.5` and `reps = 1000`, you get:

``` r
result <- bootMargin(CC = CC, CE = CE, EE = EE, thr.cause = 0.6,thr.effect =  0.6, reps = 1000)
```

The results obtained correspond to all the nodes or variables found in
the entered matrices.

The results for `$byCause` and `$byEffect` are:

For `$byCause`

``` r
result$byCause
#>    Var      Mean       LCI       UCI p.value
#> 1   I1 0.5358875 0.4918457 0.5831026   0.004
#> 2   I2 0.6238659 0.5732153 0.6722477   0.314
#> 3   I3 0.4696644 0.4092016 0.5331873   0.002
#> 4   I4 0.5253090 0.4629891 0.5896135   0.028
#> 5   I5 0.5607161 0.5091806 0.6117259   0.170
#> 6   I6 0.5979829 0.5277401 0.6655956   0.958
#> 7   I7 0.5852450 0.5299401 0.6439920   0.674
#> 8   I8 0.5788476 0.5125154 0.6414276   0.482
#> 9   I9 0.4914304 0.4305811 0.5494367   0.000
#> 10 I10 0.5301173 0.4576292 0.6004165   0.118
#> 11 I11 0.6724829 0.6106360 0.7381557   0.032
#> 12 I12 0.4908703 0.4428506 0.5417569   0.000
#> 13 I13 0.6261502 0.5313991 0.7118618   0.608
#> 14 I14 0.3113866 0.2772448 0.3492079   0.000
#> 15 I15 0.5231857 0.4818511 0.5638902   0.006
#> 16 I16 0.5593882 0.5119600 0.6065534   0.116
#> 17  B1 0.6766517 0.6000000 0.7250000   0.572
#> 18  B2 0.6779800 0.5700000 0.7950000   0.274
#> 19  B3 0.6772367 0.5500000 0.8350000   0.298
#> 20  B4 0.8084367 0.8000000 0.8200000   0.070
```

For `$byEffect`

``` r
result$byEffect
#>    Var      Mean       LCI       UCI p.value
#> 1   I1 0.5024541 0.3827982 0.6121362   0.158
#> 2   I2 0.5650923 0.4551821 0.6654083   0.458
#> 3   I3 0.4452189 0.3412909 0.5452904   0.022
#> 4   I4 0.4929149 0.3611755 0.6240607   0.148
#> 5   I5 0.4837708 0.3866276 0.5763839   0.022
#> 6   I6 0.6123865 0.4795340 0.7165727   0.994
#> 7   I7 0.5694244 0.4631833 0.6780179   0.596
#> 8   I8 0.5881156 0.5201169 0.6512122   0.792
#> 9   I9 0.4630901 0.3610464 0.5781982   0.080
#> 10 I10 0.5050021 0.4082398 0.6079619   0.080
#> 11 I11 0.5926898 0.4435680 0.7218686   0.934
#> 12 I12 0.4753970 0.3575624 0.5836353   0.064
#> 13 I13 0.5689876 0.4956154 0.6423417   0.428
#> 14 I14 0.3433080 0.2357452 0.4556898   0.000
#> 15 I15 0.4854502 0.3574170 0.6088844   0.094
#> 16 I16 0.6244008 0.5453793 0.7104083   0.630
#> 17  B1 0.6236499 0.5364683 0.7163795   0.624
#> 18  B2 0.6953728 0.6392110 0.7584409   0.006
#> 19  B3 0.7113130 0.6554383 0.7755639   0.006
#> 20  B4 0.6565891 0.5800588 0.7373038   0.158
```

For `delete = TRUE`, the function returns `$CC`, `$CE`, and `$EE`, which
are the three-dimensional arrays entered in the `CC`, `CE`, and `EE`
parameters, but with the rows and columns removed.

For `plot = TRUE`, the function returns `$plot`, which contains the
graph generated from the subsets `$byCause` and `$byEffect`. On the
x-axis are the “Dependence” associated with `$byEffect` and on the
y-axis the “Influence” is associated with `$byCause`.

### centralitry()

The `centrality()` function calculates the median betweenness
centrality, confidence intervals, and the selected method for
calculating the centrality distribution for complete graphs and chain
bipartite graphs.

The function contemplates two modalities, the first is focused on
complete graphs and the second for chain bipartite graphs.

#### For complete graphs

To calculate the median betweenness centrality of the incidence matrix
`CC`, which is described in DataSet, we use the parameter `CC`, which
allows us to enter a three-dimensional matrix, where each submatrix
along the z-axis is a square incidence matrix and reflective, or a list
of data.frame containing square and reflective incidence matrices. Each
matrix represents a complete graph. The `CE`and `EE`parameters are used
to perform the calculation with chain bipartite graphs, therefore it is
necessary that these parameters are not used.

The `centrality()` function makes use of the `“boot”` function from the
boot package (Canty A, Ripley BD, 2021) to implement the bootstrap
method with BCa tight boot. The number of bootstrap replicas is defined
in the `reps`parameter. By default `reps = 10000`.

The model parameter allows bootstrapping with some of the following
statistics: mediate.

-   `median`.
-   `conpl`: Calculate the median of a power distribution according to
    Newman M.E (2005).
-   `conlnorm`: Calculates the median of a power distribution according
    to Gillespie CS (2015).

The objective of the model parameter is to determine to which
heavy-tailed distribution the variables or nodes of the entered
parameter correspond.

For example, let `model = "median"` and `reps = 300`, we will obtain:

``` r
result <- centrality(CE = CC, model = "median", reps = 300)
#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints

#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints

#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints
```

The returned object of type data.frame contains the following
components:

-   Var: Name of the variable.
-   Median: Median calculated.
-   LCI: Lower Confidence Interval.
-   ICU: Upper Confidence Interval.
-   Method: Statistical method used associated with the model parameter.

If the median calculated for any of the betweenness centrality has a
median equal to 0, the LCI and UCI fields will have a value equal to 0.
This is reported with a warning per console.

The results are:

``` r
result
#>    Var    Median       LCI      UCI Method pValue
#> 1   I1 20.000000 7.1666667 41.50000 median     NA
#> 2   I2 14.500000 1.6753294 24.77778 median     NA
#> 3   I3  6.851190 0.3250000 12.58333 median     NA
#> 4   I4  2.079167 0.8333333 21.58333 median     NA
#> 5   I5  7.833333 0.5612783  9.00000 median     NA
#> 6   I6 28.391667 8.3380952 36.83333 median     NA
#> 7   I7 11.500000 2.0000000 41.33333 median     NA
#> 8   I8  7.416667 2.1666667 19.68810 median     NA
#> 9   I9  5.200000 3.1500000 13.50000 median     NA
#> 10 I10  4.250000 1.2500000 27.34524 median     NA
#> 11 I11 22.000000 4.3333333 30.75000 median     NA
#> 12 I12 12.516667 0.5000000 15.36667 median     NA
#> 13 I13  6.208333 2.0000000 12.37500 median     NA
#> 14 I14  0.000000 0.0000000  0.00000      0     NA
#> 15 I15  6.958333 0.2500000 51.60417 median     NA
#> 16 I16 16.166667 8.0975631 43.85417 median     NA
```

Now if we use `"conpl"` in the model parameter and 300 bootstrap
replicas, we get:

``` r
result <- centrality(CE = CC, model = "conpl", reps = 300)
#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints
#> Expected total run time for 300 sims, using 1 threads is 6.58 seconds.
#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints
#> Expected total run time for 300 sims, using 1 threads is 8.66 seconds.
#> Warning in min(which(internal[["dat"]] >= (x - .Machine$double.eps^0.5))):
#> ningún argumento finito para min; retornando Inf
#> Warning in min(which(internal[["dat"]] >= (x - .Machine$double.eps^0.5))):
#> ningún argumento finito para min; retornando Inf
#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints
#> Expected total run time for 300 sims, using 1 threads is 8.32 seconds.
#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints
#> Expected total run time for 300 sims, using 1 threads is 8.03 seconds.
#> Warning in min(which(internal[["dat"]] >= (x - .Machine$double.eps^0.5))):
#> ningún argumento finito para min; retornando Inf
#> Warning in min(which(internal[["dat"]] >= (x - .Machine$double.eps^0.5))):
#> ningún argumento finito para min; retornando Inf

#> Warning in min(which(internal[["dat"]] >= (x - .Machine$double.eps^0.5))):
#> ningún argumento finito para min; retornando Inf

#> Warning in min(which(internal[["dat"]] >= (x - .Machine$double.eps^0.5))):
#> ningún argumento finito para min; retornando Inf
#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints
#> Expected total run time for 300 sims, using 1 threads is 8.18 seconds.
#> Warning in min(which(internal[["dat"]] >= (x - .Machine$double.eps^0.5))):
#> ningún argumento finito para min; retornando Inf

#> Warning in min(which(internal[["dat"]] >= (x - .Machine$double.eps^0.5))):
#> extreme order statistics used as endpoints

#> Warning in min(which(internal[["dat"]] >= (x - .Machine$double.eps^0.5))):
#> extreme order statistics used as endpoints
#> Expected total run time for 300 sims, using 1 threads is 7.69 seconds.
#> Warning in min(which(internal[["dat"]] >= (x - .Machine$double.eps^0.5))):
#> ningún argumento finito para min; retornando Inf
#> Expected total run time for 300 sims, using 1 threads is 8.19 seconds.
#> Warning in rm(ofuss, envir = ofuss): objeto 'ofuss' no encontrado
result
#>    Var    Median       LCI       UCI Method    pValue
#> 1   I1 11.597195 5.1881310 14.946984  conpl 0.8566667
#> 2   I2 13.355431 7.2807965 15.195976  conpl 0.7000000
#> 3   I3  6.851190 0.3250000 12.583333 median        NA
#> 4   I4  2.079167 0.8333333 23.416667 median        NA
#> 5   I5  4.389108 0.4721787  4.916068  conpl 0.2233333
#> 6   I6 17.332694 6.0160536 22.436798  conpl 0.3400000
#> 7   I7 11.500000 1.5000000 41.333333 median        NA
#> 8   I8  7.416667 2.1666667 19.688095 median        NA
#> 9   I9  5.200000 3.1500000 13.500000 median        NA
#> 10 I10  4.250000 1.2500000 12.000000 median        NA
#> 11 I11 13.228170 3.2357882 17.623111  conpl 0.5166667
#> 12 I12 12.516667 0.5000000 15.366667 median        NA
#> 13 I13  3.594232 1.4489358  6.457101  conpl 0.6966667
#> 14 I14  0.000000 0.0000000  0.000000 median        NA
#> 15 I15  6.958333 2.0000000 44.458333 median        NA
#> 16 I16  6.081368 3.6244213 15.584804  conpl 0.8133333
```

**Note:** If the calculation cannot be performed with `model = "conpl"`
in some node, the function will perform the calculation with `"median"`.
This change is indicated in the Method field.

**Note:** If the calculation cannot be performed with
`model = "conlnorm"` in some node, the function will perform the
calculation with “median”. This change is indicated in the Method field

**IMPORTANT:** The best statistic to use in the model parameter will
depend on the data and the number of bootstrap replicas that you deem
appropriate.

The `centrality()` function implements the parallel function from the
boot package. The `parallel`parameter allows you to set the type of
parallel operation that is required. The options are `"multicore"`,
`"snow"` and `"no"`. By default `parallel = "no"`. The number of
processors to be used in the paralell implementation is defined in the
`ncpus`parameter. By default `ncpus = 1`.

The `parallel`and `ncpus`options are not available on Windows operating
systems.

**For chain bipartite graphs**

To calculate the median betweenness centrality of the incidence matrices
`AA`, `AB`and `BB`, which are described in DataSet, we make use of the
already described parameter `CC`. The `EE`parameter is equivalent to the
`CC`parameter. The `CE`parameter allows you to enter a three-dimensional
matrix, where each sub-matrix along the z-axis is a rectangular
incidence matrix, or a list of data.frame containing rectangular
incidence matrices. Each matrix represents a bipartite graph.

For example, let `model = "conpl"` and `reps = 300`, you get:

``` r
result <- centrality(CC = CC, CE = CE, EE = EE, model = "conpl", reps = 300)
#> Warning in min(which(internal[["dat"]] >= (x - .Machine$double.eps^0.5))):
#> ningún argumento finito para min; retornando Inf
#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints
#> Expected total run time for 300 sims, using 1 threads is 9.34 seconds.
#> Warning in min(which(internal[["dat"]] >= (x - .Machine$double.eps^0.5))):
#> ningún argumento finito para min; retornando Inf
#> Warning in min(which(internal[["dat"]] >= (x - .Machine$double.eps^0.5))):
#> ningún argumento finito para min; retornando Inf
#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints
#> Expected total run time for 300 sims, using 1 threads is 6.83 seconds.
#> Expected total run time for 300 sims, using 1 threads is 11 seconds.
#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints
#> Expected total run time for 300 sims, using 1 threads is 11 seconds.
#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints
#> Expected total run time for 300 sims, using 1 threads is 10.7 seconds.
#> Warning in min(which(internal[["dat"]] >= (x - .Machine$double.eps^0.5))):
#> ningún argumento finito para min; retornando Inf
#> Expected total run time for 300 sims, using 1 threads is 10.8 seconds.
#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints
#> Expected total run time for 300 sims, using 1 threads is 7.7 seconds.
#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints
#> Expected total run time for 300 sims, using 1 threads is 6.9 seconds.
#> Expected total run time for 300 sims, using 1 threads is 8.47 seconds.
#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints
#> Expected total run time for 300 sims, using 1 threads is 6.93 seconds.
#> Expected total run time for 300 sims, using 1 threads is 8.1 seconds.
#> Warning in min(which(internal[["dat"]] >= (x - .Machine$double.eps^0.5))):
#> ningún argumento finito para min; retornando Inf
#> Expected total run time for 300 sims, using 1 threads is 8.01 seconds.
#> Expected total run time for 300 sims, using 1 threads is 10 seconds.
#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints
#> Expected total run time for 300 sims, using 1 threads is 6.23 seconds.
#> Warning in rm(ofuss, envir = ofuss): objeto 'ofuss' no encontrado
result
#>    Var     Median        LCI       UCI Method     pValue
#> 1   I1 22.0000000  7.1666667 31.566667 median         NA
#> 2   I2 14.3563883  6.6660058 15.809344  conpl 0.62666667
#> 3   I3  8.1428571  1.1000000 14.100000 median         NA
#> 4   I4  1.7916667  0.9166667 25.950000 median         NA
#> 5   I5  4.9851140  3.2029849  6.920135  conpl 0.21666667
#> 6   I6 13.5131265  5.4879344 32.136279  conpl 0.21666667
#> 7   I7 24.9878131  9.8764227 25.800126  conpl 0.63333333
#> 8   I8  5.0604244  1.6734843 10.383603  conpl 0.82666667
#> 9   I9  3.8250000  0.2678571  8.575000 median         NA
#> 10 I10  0.4667305  0.1288655  7.971000  conpl 0.06333333
#> 11 I11 21.2412358 10.4385282 21.702917  conpl 0.68333333
#> 12 I12  7.3106674  3.2797189  7.612816  conpl 0.76666667
#> 13 I13  2.3886553  0.5215043  4.926181  conpl 0.52000000
#> 14 I14  0.0000000  0.0000000  0.000000 median         NA
#> 15 I15  2.7760383  0.2049784  6.868905  conpl 0.85000000
#> 16 I16 10.0007456  3.5688285 13.780750  conpl 0.73000000
#> 17  B1  3.5000000  1.4166667 14.600000 median         NA
#> 18  B2  1.8957816  0.6951365  2.438333  conpl 0.47666667
#> 19  B3  0.8308252  0.3506328  1.475259  conpl 0.35000000
#> 20  B4  3.4524972  0.7432283  4.271460  conpl 0.88333333
```

The `centrality()` function implements the parallel function from the
`boot`package. The `parallel`parameter allows you to set the type of
parallel operation that is required. The options are `"multicore"`,
`"snow"` and `"no"`. By default `parallel = "no"`. The number of
processors to be used in the `paralell`implementation is defined in the
`ncpus`parameter. By default `ncpus = 1`.

The `parallel`and `ncpus`options are not available on Windows operating
systems.

### fe.sq()

The function `fe.sq()`, calculates the forgotten effects (Kaufmann & Gil
Aluja, 1988) with multiple experts for complete graphs, with calculation
of the frequency of appearance of the forgotten effects, mean incidence,
confidence intervals and standard error

For example, to perform the calculation using the incidence matrix `AA`,
described in DATASET, we use the parameter `CC`, which allows us to
enter a three-dimensional matrix, where each sub-matrix along the z axis
is a square and reflective incidence matrix , or a list of data.frame
containing square and reflective incidence matrices. Each matrix
represents a complete graph.

To define the degree of truth in which the incidence is considered
significant, the parameter `thr`is used, which is defined between
`[0,1]`. By default `thr = 0.5`.

To define the maximum order of the forgotten effects, use the
`maxOrder`parameter. By default `maxOrder = 2`.

The `fe.sq()` function makes use of the `“boot”` function from the boot
package (Canty A, Ripley BD, 2021) to implement bootstrap with BCa tight
boot. The number of bootstrap replicas is defined in the `reps`
parameter. By default `reps = 10000`.

For example, let `thr = 0.5`, `maxOrder = 3` and `reps = 1000`, you get:

The returned object of type list contains two subsets of data. The
`$boot` data subset is a list of data.frame where each data.frame
represents the order of the calculated forgotten effect, the components
are:

-   From: Indicates the origin of the forgotten effects relationships.
-   Through_x: Dynamic field that represents the intermediate
    relationships of the forgotten effects. For example, for order n
    there will be “though_1” up to “though\_ \<n-1\>”.
-   To: Indicates the end of the forgotten effects relationships.
-   Count: Number of times the forgotten effect was repeated.
-   Mean: Mean effect of the forgotten effect
-   LCI: Lower Confidence Intervals.
-   UCI: Upper Confidence Intervals.
-   SE: Standard error.

The `$byExperts` data subset is a list of `data.frame` where each
`data.frame` represents the order of the forgotten effect calculated
with its associated incidence value for each expert, the components are:

-   From: Indicates the origin of the forgotten effects relationships.
-   Through_x: Dynamic field that represents the intermediate
    relationships of the forgotten effects. For example, for order n
    there will be “though_1” up to “though\_ \<n-1\>”.
-   To: Indicates the end of the forgotten effects relationships.
-   Count: Number of times the forgotten effect was repeated.
-   Expert_x: Dynamic field that represents each of the entered experts.
-   

If we look at the data in the `$boot$Order_2` data subset, we find 706
2nd order effects and 611 of these effects are unique. The first 6 are:

``` r
head(result$boot$Order_2)
#> NULL
```

The relations I8 -\> I11 -\> I10 appeared 4 times. To know exactly in
which expert these relationships were found, there is the `$byExperts`
data subset. If we look at the first row of `$byExperts$order_2` we can
identify the experts who provided this information.

``` r
head(result$byExperts$Order_2)
#> NULL
```

**IMPORTANT**: If any of the `$boot` values shows `"NA"` in LCI, UCI and
SE, it indicates that the values of the incidents per expert are the
same or the value is unique. That prevents implementing bootstrap.

The `fe.sq()` function implements the parallel function from the boot
package. The parallel parameter allows you to set the type of parallel
operation that is required. The options are `"multicore"`, `"snow"` and
`"no"`. By default `parallel = "no"`. The number of processors to be
used in the `paralell`implementation is defined in the `ncpus`parameter.
By default `ncpus = 1`.

The `parallel` and `ncpus`options are not available on Windows operating
systems.

### fe.rect()

The function `fe.rect()`, calculates the forgotten effects (Kaufmann &
Gil Aluja, 1988) with multiple key informants for chain bipartite
graphs, with calculation of the frequency of appearance of the forgotten
effects, mean incidence, confidence intervals and standard error.

To perform the calculation using the incidence matrices `AA`, `AB`and
`BB`, which are described in DataSet, we make use of the already
described parameter `CC`. The `EE` parameter is equivalent to the `CC`
parameter. The `CE` parameter allows you to enter a three-dimensional
matrix, where each sub-matrix along the z-axis is a rectangular
incidence matrix, or a list of data.frame containing rectangular
incidence matrices. Each matrix represents a bipartite graph.

To define the degree of truth in which the incidence is considered
significant, the parameter `thr` is used, which is defined between
`[0,1]`. By default `thr = 0.5`.

To define the maximum order of the forgotten effects, use the
`maxOrder`parameter. By default `maxOrder = 2`.

The `fe.rect()` function makes use of the `“boot”` function from the
boot package (Canty A, Ripley BD, 2021) to implement bootstrap with BCa
tight boot.. The number of bootstrap replicas is defined in the `reps`
parameter. By default `reps = 10000`.

For example, let `thr = 0.5`, `maxOrder = 3` and `reps = 1000`, you get:

**MPORTANT:** If any of the `$boot` values shows `"NA"` in LCI, UCI and
SE, it indicates that the values of the incidents per expert are the
same or the value is unique. That prevents implementing bootstrap.

The `fe.sq()` function implements the parallel function from the boot
package. The `parallel`parameter allows you to set the type of parallel
operation that is required. The options are `"multicore"`, `"snow"` and
`"no"`. By default `parallel = "no"`. The number of processors to be
used in the `paralell` implementation is defined in the `ncpus`
parameter. By default `ncpus = 1`.

The `parallel` and `ncpus` options are not available on Windows
operating systems.

## References

1.  Kaufmann, A., & Gil Aluja, J. (1988). Modelos para la Investigación
    de efectos olvidados, Milladoiro. Santiago de Compostela, España.

2.  Manna, E. M., Rojas-Mora, J., & Mondaca-Marino, C. (2018).
    Application of the Forgotten Effects Theory for Assessing the Public
    Policy on Air Pollution of the Commune of Valdivia, Chile. In From
    Science to Society (pp. 61-72). Springer, Cham.

3.  Freeman, L.C. (1979). Centrality in Social Networks I: Conceptual
    Clarification. Social Networks, 1, 215-239.

4.  Ulrik Brandes, A Faster Algorithm for Betweenness Centrality.
    Journal of Mathematical Sociology 25(2):163-177, 2001.

5.  Canty A, Ripley BD (2021). boot: Bootstrap R (S-Plus) Functions. R
    package version 1.3-28.

6.  Davison AC, Hinkley DV (1997). Bootstrap Methods and Their
    Applications. Cambridge University Press, Cambridge. ISBN
    0-521-57391-2, <http://statwww.epfl.ch/davison/BMA/>.

7.  Newman, M. E. (2005). Power laws, Pareto distributions and Zipf’s
    law. Contemporary physics, 46(5), 323-351.

8.  Gillespie, C. S. (2014). Fitting heavy tailed distributions: the
    poweRlaw package. arXiv preprint arXiv:1407.3492.

9.  <https://cran.r-project.org/web/packages/wBoot/index.html>
