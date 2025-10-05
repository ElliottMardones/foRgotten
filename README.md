
<!-- README.md is generated from README.Rmd. Please edit that file -->
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/ElliottMardones/foRgotten)
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
  significant within the range $[0,1]$. By default, `thr = 0.5`.
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
#>    From  To  Mean     UCI p.value
#> 1    I1  I2 0.525 0.65025   0.608
#> 2    I1  I3 0.450 0.59525   0.302
#> 3    I1  I4 0.525 0.67000   0.609
#> 4    I1  I5 0.465 0.64500   0.382
#> 5    I1  I6 0.645 0.81025   0.877
#> 6    I1  I7 0.815 0.87500   1.000
#> 7    I1  I8 0.580 0.68500   0.868
#> 8    I1  I9 0.490 0.64500   0.434
#> 9    I1 I10 0.560 0.71525   0.744
#> 10   I1 I11 0.525 0.70025   0.571
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
#> 1    I1  I2 0.525 0.64000   0.619
#> 2    I1  I3 0.450 0.59000   0.285
#> 3    I1  I4 0.525 0.66500   0.619
#> 4    I1  I5 0.465 0.65000   0.365
#> 5    I1  I6 0.645 0.80500   0.869
#> 6    I1  I7 0.815 0.87500   1.000
#> 7    I1  I8 0.580 0.69500   0.844
#> 8    I1  I9 0.490 0.63025   0.442
#> 9    I1 I10 0.560 0.71500   0.698
#> 10   I1 I11 0.525 0.69500   0.581
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
  `thr.cause = 0.5`.
- **thr.effect**: Defines the degree of truth in which incidence is
  considered significant within the range \[0,1\]. By default,
  `thr.effect = 0.5`.
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
#> 1   I1 0.5288746 0.4850285 0.5720855   0.160
#> 2   I2 0.6320074 0.5822719 0.6823816   0.000
#> 3   I3 0.4779530 0.4171946 0.5406614   0.532
#> 4   I4 0.5283726 0.4686483 0.5856516   0.416
#> 5   I5 0.5614324 0.5055512 0.6156820   0.064
#> 6   I6 0.5999455 0.5273837 0.6651388   0.014
#> 7   I7 0.5845889 0.5274503 0.6417200   0.004
#> 8   I8 0.5784128 0.5169057 0.6357332   0.026
#> 9   I9 0.4889539 0.4316205 0.5468772   0.746
#> 10 I10 0.5319239 0.4610029 0.6014430   0.402
#> 11 I11 0.6739474 0.6133202 0.7456528   0.000
#> 12 I12 0.4935499 0.4435026 0.5471019   0.728
#> 13 I13 0.6270206 0.5387675 0.7196711   0.032
#> 14 I14 0.3121708 0.2724742 0.3530755   0.000
#> 15 I15 0.5228960 0.4800429 0.5635512   0.318
#> 16 I16 0.5582789 0.5107204 0.6050015   0.022
#> 17  B1 0.6792300 0.6000000 0.7250000   0.572
#> 18  B2 0.6811050 0.5700000 0.7950000   0.078
#> 19  B3 0.6760333 0.5500000 0.8350000   0.076
#> 20  B4 0.8083700 0.8000000 0.8200000   0.074
result$byEffect
#>    Var      Mean       LCI       UCI p.value
#> 1   I1 0.5034138 0.3885049 0.6211202   0.930
#> 2   I2 0.5630319 0.4528353 0.6655500   0.356
#> 3   I3 0.4436851 0.3412848 0.5366163   0.338
#> 4   I4 0.4933484 0.3691185 0.6157560   0.832
#> 5   I5 0.4839379 0.3855560 0.5755512   0.782
#> 6   I6 0.6101467 0.4709501 0.7180465   0.352
#> 7   I7 0.5721540 0.4668115 0.6678782   0.252
#> 8   I8 0.5899297 0.5259443 0.6559122   0.024
#> 9   I9 0.4638493 0.3529988 0.5796935   0.570
#> 10 I10 0.4990418 0.3986269 0.6022319   0.890
#> 11 I11 0.5982971 0.4661995 0.7278528   0.290
#> 12 I12 0.4745791 0.3568527 0.5919389   0.708
#> 13 I13 0.5682958 0.4939141 0.6360071   0.136
#> 14 I14 0.3455048 0.2393687 0.4633647   0.024
#> 15 I15 0.4801852 0.3636298 0.5934135   0.802
#> 16 I16 0.6213836 0.5401352 0.7064578   0.016
#> 17  B1 0.6115389 0.5232464 0.7000912   0.062
#> 18  B2 0.7010378 0.6446963 0.7683036   0.000
#> 19  B3 0.7053441 0.6456897 0.7723650   0.000
#> 20  B4 0.6510719 0.5673456 0.7385614   0.002
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
#> 1   I1 14.5928488 13.1436008 20.224670  conpl   0.96
#> 2   I2 14.3563883  6.9466404 15.563849  conpl   0.56
#> 3   I3  8.1428571  1.1000000 14.100000 median     NA
#> 4   I4  0.6304530  0.1381956  1.405786  conpl   0.52
#> 5   I5  4.9851140  4.3496498  5.758809  conpl   0.33
#> 6   I6 13.5131265  0.8199258 31.937296  conpl   0.20
#> 7   I7 24.9878131 24.5403580 25.213540  conpl   0.66
#> 8   I8  5.0604244  1.5671087  6.956965  conpl   0.78
#> 9   I9  3.8250000  0.2678571  5.200000 median     NA
#> 10 I10  0.4667305  0.1291545  3.810338 median     NA
#> 11 I11 21.2412358 13.2306966 21.849872  conpl   0.70
#> 12 I12  7.3106674  4.7113149  7.558573  conpl   0.75
#> 13 I13  2.3886553  0.5248796  7.079924  conpl   0.52
#> 14 I14  0.0000000  0.0000000  0.000000 median     NA
#> 15 I15  2.7760383  0.2009119  6.581992  conpl   0.80
#> 16 I16 10.0007456  3.8778130 12.993326  conpl   0.78
#> 17  B1  3.5000000  1.4166667  4.500000 median     NA
#> 18  B2  1.8957816  0.7112538  2.385453  conpl   0.48
#> 19  B3  0.8308252  0.3314167  1.462390  conpl   0.41
#> 20  B4  5.6666667  1.7333333  8.000000 median     NA
```

If any variable cannot be calculated with `model = "conpl"` it will be
calculated with `model = "median"`.

#### Example: Complete graphs

Complete graphs only make use of the `CE` parameter. Here is an example:

``` r
result <- centrality(CE = CC, model = "median", reps = 500)
result
#>    Var    Median       LCI       UCI Method pValue
#> 1   I1 20.000000 7.2916667 41.500000 median     NA
#> 2   I2 14.500000 2.5000000 24.777778 median     NA
#> 3   I3  6.851190 0.3250000 12.583333 median     NA
#> 4   I4  2.079167 0.8333333 21.583333 median     NA
#> 5   I5  7.833333 0.3250000  8.333333 median     NA
#> 6   I6 28.391667 8.3380952 36.833333 median     NA
#> 7   I7 11.500000 2.0000000 41.333333 median     NA
#> 8   I8  7.416667 2.1666667 15.177381 median     NA
#> 9   I9  5.200000 3.1500000 13.500000 median     NA
#> 10 I10  4.250000 1.2500000 12.000000 median     NA
#> 11 I11 22.000000 4.3333333 30.750000 median     NA
#> 12 I12 12.516667 0.5000000 15.366667 median     NA
#> 13 I13  6.208333 2.0000000 12.375000 median     NA
#> 14 I14  0.000000 0.0000000  0.000000 median     NA
#> 15 I15  6.958333 2.0000000 44.458333 median     NA
#> 16 I16 16.166667 8.5769841 43.854167 median     NA
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
  will be \$Through\_{1}\$ up to \$Through\_{n-1}\$.
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
  will be $Through_{1}$ up to $Through_{n-1}$.
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
#> 1   I1       I11 B1     2 0.800 0.6 0.800 0.14155875
#> 2   I8        I7 B1     2 0.725 0.6 0.725 0.09020738
#> 3  I14       I15 B2     2 0.725 0.7 0.750 0.01812037
#> 4  I10       I11 B3     2 0.600  NA    NA         NA
#> 5  I14       I15 B3     2 0.725 0.7 0.725 0.01765945
#> 6   I9        B3 B1     2 0.725 0.7 0.725 0.01742681
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
#> 1  I10     I11 I14   208 0.6689026 0.09407256
#> 2   I3      I6  I9   190 0.6452615 0.08234789
#> 3  I13     I16  I1   184 0.6355942 0.08108535
#> 4  I13      I6  I9   178 0.6575168 0.09256458
#> 5   I8     I13 I10   175 0.7102929 0.10568339
#> 6   I8      I6  I9   164 0.6506200 0.09933247
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
