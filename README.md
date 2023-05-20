
<!-- README.md is generated from README.Rmd. Please edit that file -->

# foRgotten

<!-- badges: start -->
<!-- badges: end -->

## Description

The **foRgotten** library extends the theory of forgotten effects by
aggregating multiple key informants for complete and chained bipartite
graphs.

The package allows for the following:

- Calculation of the average incidence by edges for direct effects.
- Calculation of the average incidence per cause and effect for direct
  effects.
- Calculation of the median betweenness centrality per node for direct
  effects.
- Calculation of the forgotten effects.
- Use of complete graphs and chain bipartite graphs.

## Authors

**Elliott Jamil Mardones Arias**  
School of Computer Science  
Universidad Católica de Temuco  
Rudecindo Ortega 02351  
Temuco, Chile  
<elliott.mardones@uct.cl>

**Julio Rojas-Mora**  
Department of Computer Science  
Universidad Católica de Temuco  
Rudecindo Ortega 02351  
Temuco, Chile  
and  
Centro de Políticas Públicas Universidad Católica de Temuco  
Temuco, Chile  
<julio.rojas@uct.cl>

## Installation

You can install the stable version of **foRgotten** from CRAN with:

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
?directEffects()
```

Using multiple key informants, it calculates the mean incidence,
left-sided confidence interval, and p-value for complete and chained
bipartite graphs. For more details, see help(directEffects).

``` r
?bootMargin()
```

Using multiple key informants, it calculates the mean incidence,
left-sided confidence interval, and p-value for complete and chained
bipartite graphs. For more details, see help(bootMargin).

``` r
?centrality()
```

Using multiple key informants, it calculates the median betweenness
centrality, confidence intervals, and the selected method for
calculating the centrality distribution for complete and chained
bipartite graphs. For more details, see help(centrality).

``` r
?FE()
```

Using multiple key informants, it calculates the forgotten effects, the
frequency of their occurrence, the mean incidence, the confidence
intervals, and the standard error for complete and chained bipartite
graphs. For more details, see help(FE).

## DataSet

The library provides three three-dimensional incidence matrices: `CC`,
`CE`, and `EE`. The data are those used in the study “Application of the
Forgotten Effects Theory For Assessing the Public Policy on Air
Pollution Of the Commune of Valdivia, Chile” developed by Manna, E. M et
al. (2018).

The data consists of 16 incentives, four behaviors, and ten key
informants, where each of the key informants presented the data with a
minimum and maximum value for each incident. The data description can be
seen in Tables 1 and 2 of Manna, E. M et al. (2018).

The **foRgotten** library presents the data with the average between the
minimum and maximum value for each incidence, C being the equivalent to
incentives and E to behaviors.

The examples in this document make use of this data. For more details,
you can consult the following:

``` r
help(CC)
help(CE)
help(EE)
```

## Examples

## **directEffects()**

The `directEffects()` function calculates the mean incidence, left-sided
confidence interval, and p-value for complete and chained bipartite
graphs using multiple key informants. This function performs a t-test
with left one-sided contrast via bootstrap BCa.

The function returns a list object with the subset of data
`$DirectEffects` that includes the following information:

- **From**: Origin of the incidence.
- **To**: Destination of the incidence.
- **Mean**: Average incidence.
- **UCI**: Upper confidence interval.
- **p.value**: Calculated p-value.

### Parameters

- **CC**: It allows for entering a three-dimensional incidence array,
  with each submatrix along the z-axis being a square incidence matrix.
  By default, `CC = NULL`.
- **CE**: It allows for entering a three-dimensional incidence array,
  with each submatrix along the z-axis being a square incidence matrix
  (for complete graphs) or a rectangular matrix (for chained bipartite
  graphs).
- **EE**: It allows for entering a three-dimensional incidence array,
  with each submatrix along the z-axis being a square incidence matrix.
  By default, `EE = NULL`.
- **thr**: Defines the degree of truth in which incidence is considered
  significant within the range \[0,1\]. By default, `thr = 0.5`.
- **conf.level**: Defines the confidence level. By default,
  `conf.level = 0.95`.
- **reps**: Defines the number of bootstrap replicates. By default,
  `reps = 10000`.
- **delete**: Removes the non-significant results from the
  `$DirectEffects` set and returns the entered three-dimensional
  incidence arrays by assigning zeros to the edges whose incidences are
  significantly lower than `thr` at the p-value set in the `conf.level`
  parameter. By default, `delete = FALSE`.

#### Example: Chained bipartite graphs

For example, to calculate the average incidence for each edge of the
three-dimensional incidence arrays `CC`, `CE`, and `EE`, with the
parameters `thr = 0.5` and `reps = 1000`, we use the `directEffects()`
function:

``` r
result <- directEffects(CC = CC, CE = CE, EE = EE, thr = 0.5, reps = 1000)
```

The result obtained is a data.frame of 312 rows. The first ten items are
displayed.

``` r
result$DirectEffects[1:10,]
#>    From  To  Mean   UCI p.value
#> 1    I1  I2 0.525 0.650   0.615
#> 2    I1  I3 0.450 0.595   0.315
#> 3    I1  I4 0.525 0.660   0.611
#> 4    I1  I5 0.465 0.640   0.390
#> 5    I1  I6 0.645 0.810   0.859
#> 6    I1  I7 0.815 0.880   1.000
#> 7    I1  I8 0.580 0.695   0.854
#> 8    I1  I9 0.490 0.635   0.449
#> 9    I1 I10 0.560 0.700   0.723
#> 10   I1 I11 0.525 0.695   0.597
```

Any result that contains a NA value in the UCI and p.value fields
indicates that all occurrences are equal or that the value is unique.
Therefore, bootstrapping is not done.

The `delete` parameter allows assigning zeros to the edges whose
incidences are non-significant.

``` r
result <- directEffects(CC = CC, CE = CE, EE = EE, thr = 0.5, reps = 1000, delete = TRUE)
#> deleting data...
#> deleting data...
#> There is no data to delete...
```

The number of average incidences decreased from 312 to 283.
Additionally, for `delete = TRUE`, the function returns the
three-dimensional incidence arrays entered but assigns zero to
insignificant edges.

``` r
names(result)
#> [1] "CC"            "CE"            "EE"            "DirectEffects"
```

#### Example: Complete Graphs

Complete graphs only make use of the `CE` parameter. Here is an example:

``` r
result <- directEffects(CE = CC, thr = 0.5, reps = 1000)
result$DirectEffects[1:10,]
#>    From  To  Mean     UCI p.value
#> 1    I1  I2 0.525 0.65500   0.595
#> 2    I1  I3 0.450 0.60000   0.281
#> 3    I1  I4 0.525 0.66500   0.596
#> 4    I1  I5 0.465 0.65000   0.374
#> 5    I1  I6 0.645 0.80500   0.877
#> 6    I1  I7 0.815 0.88000   1.000
#> 7    I1  I8 0.580 0.69500   0.846
#> 8    I1  I9 0.490 0.62525   0.464
#> 9    I1 I10 0.560 0.71000   0.734
#> 10   I1 I11 0.525 0.69500   0.562
```

## bootMargin()

The `bootMargin()` function calculates the mean incidence of each cause
and each effect, confidence intervals, and p-value for complete and
chained bipartite graphs using multiple key informants. This function
performs a t-test with bilateral contrast via bootstrap BCa.

The function returns a list object with the subset of data `$byCause`
and `$byEffect`, which includes the following information:

- **Var**: Name of the variable.
- **Mean**: Average incidence.
- **LCI**: Lower confidence interval.
- **UCI**: Upper confidence interval.
- **p.value**: calculated p-value.

### Parameters

- **CC**: It allows for entering a three-dimensional incidence array,
  with each submatrix along the z-axis being a square incidence matrix.
  By default, `CC = NULL`.
- **CE**: It allows for entering a three-dimensional incidence array,
  with each submatrix along the z-axis being a square incidence matrix
  (for complete graphs) or a rectangular matrix (for chained bipartite
  graphs).
- **EE**: It allows for entering a three-dimensional incidence array,
  with each submatrix along the z-axis being a square incidence matrix.
  By default, `EE = NULL`.
- **no.zeros:** For `no-zeros = TRUE`, the function omits zeros in the
  calculations. By default, `no-zeros = TRUE`.
- **thr.cause**: Defines the degree of truth in which incidence is
  considered significant within the range \[0,1\]. By default,
  `thr = 0.5`.
- **thr.effect**: Defines the degree of truth in which incidence is
  considered significant within the range \[0,1\]. By default,
  `thr = 0.5`.
- **conf.level**: Defines the confidence level. By default,
  `conf.level = 0.95`.
- **reps**: Defines the number of bootstrap replicates. By default,
  `reps = 10000`.
- **delete**: Removes the non-significant results from the
  `$DirectEffects` set and returns the entered three-dimensional
  incidence arrays by assigning zeros to the edges whose incidences are
  significantly lower than `thr` at the p-value set in the `conf.level`
  parameter. By default, `delete = FALSE`.
- **plot:** Generates a Dependence-Influence plot with the data from
  `$byCause` and `$byEffect`. The “Dependence” associated with
  `$byEffect` is on the X-axis, and the “Influence” associated with
  `$byCause` is on the Y-axis.

#### 

#### Example: Chained bipartite graphs

For example, to calculate the mean incidence of each cause and effect of
the three-dimensional incidence arrays `CC`, `CE`, and `EE`, with the
parameters `thr.cause = 0.5`, `thr.effect = 0.5`, `reps = 1000`, and
`plot = TRUE`, we use the `bootMargin()` function.

``` r
result <- bootMargin(CC = CC, CE = CE, EE = EE, thr.cause = 0.5, thr.effect = 0.5, reps = 1000, plot = TRUE)
```

The results obtained are the data.frame `$byCause` and `$byEffect`,
their values are:

``` r
result$byCause
#>    Var      Mean       LCI       UCI p.value
#> 1   I1 0.5305503 0.4895249 0.5777727   0.188
#> 2   I2 0.6324221 0.5836820 0.6807259   0.002
#> 3   I3 0.4792114 0.4160250 0.5344335   0.452
#> 4   I4 0.5294861 0.4711972 0.5870174   0.436
#> 5   I5 0.5604924 0.5056067 0.6145095   0.058
#> 6   I6 0.6013527 0.5362126 0.6710686   0.014
#> 7   I7 0.5864937 0.5268662 0.6470300   0.016
#> 8   I8 0.5790057 0.5129159 0.6429371   0.056
#> 9   I9 0.4885084 0.4301146 0.5468048   0.768
#> 10 I10 0.5322804 0.4589958 0.6101036   0.420
#> 11 I11 0.6732543 0.6103487 0.7386477   0.000
#> 12 I12 0.4922275 0.4426697 0.5467016   0.782
#> 13 I13 0.6292472 0.5415811 0.7140636   0.018
#> 14 I14 0.3123689 0.2756969 0.3497605   0.000
#> 15 I15 0.5237869 0.4800531 0.5646226   0.328
#> 16 I16 0.5575765 0.5137825 0.6017434   0.022
#> 17  B1 0.6779800 0.6000000 0.7250000   0.600
#> 18  B2 0.6800800 0.6041250 0.7950000   0.054
#> 19  B3 0.6775850 0.5500000 0.8350000   0.086
#> 20  B4 0.8084600 0.8000000 0.8200000   0.072
result$byEffect
#>    Var      Mean       LCI       UCI p.value
#> 1   I1 0.5059179 0.3943478 0.6162695   0.954
#> 2   I2 0.5623358 0.4574103 0.6682551   0.336
#> 3   I3 0.4456614 0.3374815 0.5556432   0.352
#> 4   I4 0.4874150 0.3752149 0.6106548   0.928
#> 5   I5 0.4851392 0.3813033 0.5739393   0.726
#> 6   I6 0.6142810 0.4966121 0.7192652   0.360
#> 7   I7 0.5707686 0.4727442 0.6696705   0.236
#> 8   I8 0.5877908 0.5235298 0.6546214   0.022
#> 9   I9 0.4663525 0.3640060 0.5776167   0.538
#> 10 I10 0.5049185 0.4070113 0.6076268   0.982
#> 11 I11 0.5980826 0.4613840 0.7267028   0.272
#> 12 I12 0.4741979 0.3575660 0.5854975   0.696
#> 13 I13 0.5681229 0.4945974 0.6433417   0.174
#> 14 I14 0.3445864 0.2336660 0.4618391   0.026
#> 15 I15 0.4805417 0.3569777 0.5992417   0.820
#> 16 I16 0.6244110 0.5390013 0.7138683   0.032
#> 17  B1 0.6112664 0.5204443 0.7067610   0.044
#> 18  B2 0.7016099 0.6449859 0.7641147   0.000
#> 19  B3 0.7026121 0.6424032 0.7705452   0.000
#> 20  B4 0.6536630 0.5713163 0.7454479   0.002
```

The parameter `plot = TRUE` generates the Dependency-Influence plane
based on the results obtained.

``` r
result$plot
```

<img src="man/figures/README-unnamed-chunk-15-1.png" width="100%" />

The parameter `delete = TRUE` eliminates the causes and effects whose
average incidences are non-significant to the parameters `thr.cause` and
`thr.effect` set.

``` r
result <- bootMargin(CC = CC, CE = CE, EE = EE, thr.cause = 0.5, thr.effect = 0.5, reps = 1000, plot = TRUE, delete = TRUE)
```

The variable I14 was removed from the new Dependence-Influence plane.

``` r
result$plot
```

<img src="man/figures/README-unnamed-chunk-17-1.png" width="100%" />

Also, for `delete = TRUE`, the function returns the three-dimensional
incidence matrices entered but removed non-significant causes and
effects.

``` r
names(result)
#> [1] "CC"       "CE"       "EE"       "byCause"  "byEffect" "plot"
```

#### Example: Complete Graphs

Complete graphs only make use of the `CE` parameter. Here is an example:

``` r
result <- bootMargin(CE = CC, thr.cause = 0.5, thr.effect = 0.5, reps = 1000, plot = TRUE)
result$plot
```

<img src="man/figures/README-unnamed-chunk-19-1.png" width="100%" />

## centralitry()

The `centrality()` function calculates the median betweenness
centrality, confidence intervals, and the selected method for
calculating the centrality distribution for complete and chained
bipartite graphs using multiple key informants.

The function returns an object of type data.frame that contains the
following components:

- **Var**: Name of the variable.
- **Median**: Median calculated.
- **LCI**: Lower Confidence Interval.
- **UCI**: Upper Confidence Interval.
- **Method**: Statistical method used associated with the model
  parameter.

### Parameters

- **CC**: It allows for entering a three-dimensional incidence array,
  with each submatrix along the z-axis being a square incidence matrix.
  By default, `CC = NULL`.
- **CE**: It allows for entering a three-dimensional incidence array,
  with each submatrix along the z-axis being a square incidence matrix
  (for complete graphs) or a rectangular matrix (for chained bipartite
  graphs).
- **EE**: It allows for entering a three-dimensional incidence array,
  with each submatrix along the z-axis being a square incidence matrix.
  By default, `EE = NULL`.
- **model:** Allows you to determine to which heavy-tailed distribution
  the entered variables correspond.
- **conf.level**: Defines the confidence level. By default,
  `conf.level = 0.95`.
- **reps**: Defines the number of bootstrap replicates. By default,
  `reps = 10000`.
- **parallel:** Sets the type of parallel operation required. The
  options are “multicore”, “snow”, and “no”. By default,
  `parallel = "no"`.
- **ncpus:** Defines the number of cores to use. By default,
  `ncpus = 1`.

#### Example: Chained bipartite graphs

For example, to calculate the median betweenness centrality of each node
of the three-dimensional incidence arrays `CC`, `CE`, and `EE`, with the
parameters `model = "conpl"` and `reps = 100`, we use the `centrality()`
function.

``` r
result <- centrality(CC = CC, CE = CE, EE = EE, model = "conpl", reps = 100)
```

The results obtained are:

``` r
result
#>    Var     Median        LCI       UCI Method pValue
#> 1   I1 22.0000000  7.1823179 46.000000 median     NA
#> 2   I2 14.3563883  6.6494689 15.563849  conpl   0.76
#> 3   I3  8.1428571  1.1000000 14.100000 median     NA
#> 4   I4  0.6304530  0.1251884  1.267909  conpl   0.34
#> 5   I5  4.9851140  0.6702616  6.050534  conpl   0.22
#> 6   I6 13.5131265  5.5004750 31.937296  conpl   0.29
#> 7   I7 24.9878131  9.6930173 25.683050  conpl   0.63
#> 8   I8  5.0604244  2.9711133 10.129009  conpl   0.81
#> 9   I9  3.8250000  0.3839286  9.350000 median     NA
#> 10 I10  0.4667305  0.1305429  3.728494  conpl   0.09
#> 11 I11 21.2412358 13.1628603 21.849872  conpl   0.71
#> 12 I12  7.3106674  4.5669193  7.503151  conpl   0.71
#> 13 I13  2.3886553  0.4917829  4.310752  conpl   0.46
#> 14 I14  0.0000000  0.0000000  0.000000 median     NA
#> 15 I15  5.5000000  0.4184627 25.045238 median     NA
#> 16 I16 10.0007456  3.4564095 13.139199  conpl   0.85
#> 17  B1  3.5000000  1.4166667  4.500000 median     NA
#> 18  B2  1.8957816  0.7044555  2.287973  conpl   0.45
#> 19  B3  0.8308252  0.3519512  1.523022  conpl   0.45
#> 20  B4  5.6666667  1.7333333  7.083333 median     NA
```

If any variable cannot be calculated with `model = "conpl"` it will be
calculated with `model = "median"`.

#### Example: Complete graphs

Complete graphs only make use of the `CE` parameter. Here is an example:

``` r
result <- centrality(CE = CC, model = "median", reps = 500)
result
#>    Var    Median       LCI      UCI Method pValue
#> 1   I1 20.000000 7.1666667 22.31667 median     NA
#> 2   I2 14.500000 1.8384062 24.77778 median     NA
#> 3   I3  6.851190 0.3250000 12.58333 median     NA
#> 4   I4  2.079167 0.8333333 21.58333 median     NA
#> 5   I5  7.833333 0.6666667  9.00000 median     NA
#> 6   I6 28.391667 8.3380952 36.83333 median     NA
#> 7   I7 11.500000 1.5000000 41.33333 median     NA
#> 8   I8  7.416667 2.1666667 15.17738 median     NA
#> 9   I9  5.200000 3.1500000 13.50000 median     NA
#> 10 I10  4.250000 1.2500000 12.00000 median     NA
#> 11 I11 22.000000 0.7500000 30.75000 median     NA
#> 12 I12 12.516667 0.5000000 15.36667 median     NA
#> 13 I13  6.208333 2.0000000 14.83333 median     NA
#> 14 I14  0.000000 0.0000000  0.00000 median     NA
#> 15 I15  6.958333 2.0000000 44.45833 median     NA
#> 16 I16 16.166667 8.5769841 43.85417 median     NA
```

## FE()

The `FE()` function calculates the forgotten effects, the frequency of
their occurrence, the mean incidence, the confidence intervals, and the
standard error for complete and chained bipartite graphs using multiple
key informants. This function implements bootstrap BCa.

The function returns two list-type objects. The first is `$boot`, which
contains the following information:

- **From**: Indicates the origin of the forgotten effects relationships.
- **\$Through\_{x}\$**: Dynamic field that represents the intermediate
  relationships of the forgotten effects. For example, for order n there
  will be \$Though\_{1}\$ up to \$Though\_{n-1}\$.
- **To**: Indicates the end of the forgotten effects relationships.
- **Count**: Number of times the forgotten effect was repeated.
- **Mean**: Mean effect of the forgotten effect
- **LCI**: Lower Confidence Intervals.
- **UCI**: Upper Confidence Intervals.
- **SE**: Standard error.

And the second is `$byExpert`, which contains the following information:

- **From**: Indicates the origin of the forgotten effects relationships.
- $Through_{x}$: Dynamic field that represents the intermediate
  relationships of the forgotten effects. For example, for order n there
  will be $Though_{1}$ up to $Though_{n-1}$.
- **To**: Indicates the end of the forgotten effects relationships.
- **Count**: Number of times the forgotten effect was repeated.
- $Expert_x$: Dynamic field that represents each of the entered experts.

### 

#### Parameters

- **CC:** It allows for entering a three-dimensional incidence array,
  with each submatrix along the z-axis being a square incidence matrix.
  By default, `CC = NULL`.
- **CE:** It allows for entering a three-dimensional incidence array,
  with each submatrix along the z-axis being a square incidence matrix
  (for complete graphs) or a rectangular matrix (for chained bipartite
  graphs).
- **EE:** It allows for entering a three-dimensional incidence array,
  with each submatrix along the z-axis being a square incidence matrix.
  By default, `EE = NULL`.
- **mode**: Specify the mode for the FE function. If the mode is set to
  ‘Per-Expert,’ the function will calculate using all experts. If the
  mode is set to ‘Empirical,’ the function will utilize this method.
- **thr:** Defines the degree of truth in which incidence is considered
  significant within the range $[0,1]$. By default, `thr = 0.5`.
- **maxOrder:** Defines the limit of forgotten effects to calculate (if
  they exist). By default, `maxOrder = 2`.
- **reps:** Defines the number of bootstrap replicates. By default,
  `reps = 10000`.
- **parallel:** Sets the type of parallel operation required. The
  options are “multicore”, “snow”, and “no”. By default,
  `parallel = "no"`**.**
- **ncpus:** Defines the number of cores to use. By default,
  `ncpus = 1`.

#### Example: Chained bipartite graphs

For example, to calculate the forgotten effects of three-dimensional
incidence arrays `CC`, `CE`, and `EE`, with `thr = 0.5`, `maxOrder = 3`,
and `reps = 1000`, we use the `FE()` function.

``` r
result <- FE(CC = CC, CE = CE, EE = EE, mode = 'Per-Expert', thr = 0.5, maxOrder = 3, reps = 1000)
#> Warning in FE_bootstrap(CC = CC, CE = CE, EE = EE, thr = thr, maxOrder =
#> maxOrder, : Expert number 7 has no 2nd maxOrder or higher effects.
```

The results are in the `$boot` list, which contains the forgotten
effects sorted in order.

``` r
names(result$boot)
#> [1] "Order_2"
```

The results of the forgotten effects of the second order are:

``` r
head(result$boot$Order_2)
#>   From Through_1 To Count  Mean LCI   UCI         SE
#> 1   I1       I11 B1     2 0.800 0.6 0.800 0.14075088
#> 2   I8        I7 B1     2 0.725 0.6 0.725 0.08824277
#> 3  I14       I15 B2     2 0.725 0.7 0.725 0.01719710
#> 4  I10       I11 B3     2 0.600  NA    NA         NA
#> 5  I14       I15 B3     2 0.725 0.7 0.725 0.01784104
#> 6   I9        B3 B1     2 0.725 0.7 0.750 0.01799865
```

Any result containing an NA value in the LCI, UCI, and SE fields
indicates that all incidences are the same or that the value is unique.
Therefore, bootstrapping is not done.

The `$byExpert` list indicates in which expert the forgotten effect is
generated.

#### 

#### Example: Complete graphs

When working with complete graphs, it is necessary to specify either the
`CC` and `CE` parameters or the `CE` and `EE` parameters (as they are
equivalent). Here is an example:

``` r
result <- FE(CC = CC, CE = CC, thr = 0.5,mode = "Empirical", maxOrder = 3, reps = 1000)
#> [1] "Replica:  100"
#> [1] "Replica:  200"
#> [1] "Replica:  300"
#> [1] "Replica:  400"
#> [1] "Replica:  500"
#> [1] "Replica:  600"
#> [1] "Replica:  700"
#> [1] "Replica:  800"
#> [1] "Replica:  900"
#> [1] "Replica:  1000"
names(result)
#> [1] "Order_2" "Order_3"
head(result$Order_2)
#>   From Through  To Count      Mean         SD
#> 1  I10     I11 I14   211 0.6621804 0.08450907
#> 2  I13     I16  I1   198 0.6451819 0.08029232
#> 3   I3      I6  I9   185 0.6405935 0.08474480
#> 4   I8     I13 I10   182 0.7219362 0.10412470
#> 5   I8      I6  I9   172 0.6615442 0.10459733
#> 6   I7      I6  I9   163 0.6815600 0.10016237
```

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

9.  Kohl, M., & Kohl, M. M. (2020). Package ‘MKinfer’.

## Citation

``` r
citation("foRgotten")
#> To cite foRgotten in publications use:
#> 
#>   Mardones-Arias, E.; Rojas-Mora, J. foRgotten.
#>   https://github.com/ElliottMardones/foRgotten
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {foRgotten},
#>     author = {Elliott Mardones-Arias and Julio Rojas-Mora},
#>     year = {2022},
#>     note = {R package version 1.1.0},
#>     url = {https://github.com/ElliottMardones/foRgotten},
#>   }
```
