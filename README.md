<!-- README.md is generated from README.Rmd. Please edit that file -->

# foRgotten

<!-- badges: start -->

<!-- badges: end -->

## Description

The **foRgotten** library extends the theory of forgotten effects by aggregating multiple key informants for complete and chained bipartite graphs.

The package allows for the following:

-   Calculation of the average incidence by edges for direct effects.
-   Calculation of the average incidence per cause and effect for direct effects.
-   Calculation of the median betweenness centrality per node for direct effects.
-   Calculation of the forgotten effects.
-   Use of complete graphs and chain bipartite graphs.

## Authors

**Elliott Jamil Mardones Arias**\
School of Computer Science\
Universidad Católica de Temuco\
Rudecindo Ortega 02351\
Temuco, Chile\
[elliott.mardones\@uct.cl](mailto:elliott.mardones@uct.cl){.email}

**Julio Rojas-Mora**\
Department of Computer Science\
Universidad Católica de Temuco\
Rudecindo Ortega 02351\
Temuco, Chile\
and\
Centro de Políticas Públicas Universidad Católica de Temuco\
Temuco, Chile\
[julio.rojas\@uct.cl](mailto:julio.rojas@uct.cl){.email}

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

Using multiple key informants, it calculates the mean incidence, left-sided confidence interval, and p-value for complete and chained bipartite graphs. For more details, see help(directEffects).

``` r
?bootMargin()
```

Using multiple key informants, it calculates the mean incidence, left-sided confidence interval, and p-value for complete and chained bipartite graphs. For more details, see help(bootMargin).

``` r
?centrality()
```

Using multiple key informants, it calculates the median betweenness centrality, confidence intervals, and the selected method for calculating the centrality distribution for complete and chained bipartite graphs. For more details, see help(centrality).

``` r
?FE()
```

Using multiple key informants, it calculates the forgotten effects, the frequency of their occurrence, the mean incidence, the confidence intervals, and the standard error for complete and chained bipartite graphs. For more details, see help(FE).

## DataSet

The library provides three three-dimensional incidence matrices: `CC`, `CE`, and `EE`. The data are those used in the study "Application of the Forgotten Effects Theory For Assessing the Public Policy on Air Pollution Of the Commune of Valdivia, Chile" developed by Manna, E. M et al. (2018).

The data consists of 16 incentives, four behaviors, and ten key informants, where each of the key informants presented the data with a minimum and maximum value for each incident. The data description can be seen in Tables 1 and 2 of Manna, E. M et al. (2018).

The **foRgotten** library presents the data with the average between the minimum and maximum value for each incidence, C being the equivalent to incentives and E to behaviors.

The examples in this document make use of this data. For more details, you can consult the following:

``` r
help(CC)
help(CE)
help(EE)
```

## Examples

## **directEffects()**

The `directEffects()` function calculates the mean incidence, left-sided confidence interval, and p-value for complete and chained bipartite graphs using multiple key informants. This function performs a t-test with left one-sided contrast via bootstrap BCa.

The function returns a list object with the subset of data `$DirectEffects` that includes the following information:

-   **From**: Origin of the incidence.
-   **To**: Destination of the incidence.
-   **Mean**: Average incidence.
-   **UCI**: Upper confidence interval.
-   **p.value**: Calculated p-value.

### Parameters

-   **CC**: It allows for entering a three-dimensional incidence array, with each submatrix along the z-axis being a square incidence matrix. By default, `CC = NULL`.
-   **CE**: It allows for entering a three-dimensional incidence array, with each submatrix along the z-axis being a square incidence matrix (for complete graphs) or a rectangular matrix (for chained bipartite graphs).
-   **EE**: It allows for entering a three-dimensional incidence array, with each submatrix along the z-axis being a square incidence matrix. By default, `EE = NULL`.
-   **thr**: Defines the degree of truth in which incidence is considered significant within the range $$0,1$$. By default, `thr = 0.5`.
-   **conf.level**: Defines the confidence level. By default, `conf.level = 0.95`.
-   **reps**: Defines the number of bootstrap replicates. By default, `reps = 10000`.
-   **delete**: Removes the non-significant results from the `$DirectEffects` set and returns the entered three-dimensional incidence arrays by assigning zeros to the edges whose incidences are significantly lower than `thr` at the p-value set in the `conf.level` parameter. By default, `delete = FALSE`.

#### Example: Chained bipartite graphs

For example, to calculate the average incidence for each edge of the three-dimensional incidence arrays `CC`, `CE`, and `EE`, with the parameters `thr = 0.5` and `reps = 1000`, we use the `directEffects()` function:

``` r
result <- directEffects(CC = CC, CE = CE, EE = EE, thr = 0.5, reps = 1000)
```

The result obtained is a data.frame of 312 rows. The first ten items are displayed.

``` r
result$DirectEffects[1:10,]
#>    From  To  Mean     UCI p.value
#> 1    I1  I2 0.525 0.65500   0.613
#> 2    I1  I3 0.450 0.58500   0.313
#> 3    I1  I4 0.525 0.66525   0.654
#> 4    I1  I5 0.465 0.64500   0.380
#> 5    I1  I6 0.645 0.79500   0.870
#> 6    I1  I7 0.815 0.87500   1.000
#> 7    I1  I8 0.580 0.69000   0.855
#> 8    I1  I9 0.490 0.63500   0.459
#> 9    I1 I10 0.560 0.69525   0.727
#> 10   I1 I11 0.525 0.69500   0.578
```

Any result that contains a NA value in the UCI and p.value fields indicates that all occurrences are equal or that the value is unique. Therefore, bootstrapping is not done.

The `delete` parameter allows assigning zeros to the edges whose incidences are non-significant.

``` r
result <- directEffects(CC = CC, CE = CE, EE = EE, thr = 0.5, reps = 1000, delete = TRUE)
#> deleting data...
#> deleting data...
#> There is no data to delete...
```

The number of average incidences decreased from 312 to 283. Additionally, for `delete = TRUE`, the function returns the three-dimensional incidence arrays entered but assigns zero to insignificant edges.

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
#> 1    I1  I2 0.525 0.65025   0.615
#> 2    I1  I3 0.450 0.59000   0.292
#> 3    I1  I4 0.525 0.65500   0.606
#> 4    I1  I5 0.465 0.64000   0.370
#> 5    I1  I6 0.645 0.81500   0.836
#> 6    I1  I7 0.815 0.87500   1.000
#> 7    I1  I8 0.580 0.68500   0.865
#> 8    I1  I9 0.490 0.63500   0.460
#> 9    I1 I10 0.560 0.71000   0.730
#> 10   I1 I11 0.525 0.68500   0.610
```

## bootMargin()

The `bootMargin()` function calculates the mean incidence of each cause and each effect, confidence intervals, and p-value for complete and chained bipartite graphs using multiple key informants. This function performs a t-test with bilateral contrast via bootstrap BCa.

The function returns a list object with the subset of data `$byCause` and `$byEffect`, which includes the following information:

-   **Var**: Name of the variable.
-   **Mean**: Average incidence.
-   **LCI**: Lower confidence interval.
-   **UCI**: Upper confidence interval.
-   **p.value**: calculated p-value.

### Parameters

-   **CC**: It allows for entering a three-dimensional incidence array, with each submatrix along the z-axis being a square incidence matrix. By default, `CC = NULL`.
-   **CE**: It allows for entering a three-dimensional incidence array, with each submatrix along the z-axis being a square incidence matrix (for complete graphs) or a rectangular matrix (for chained bipartite graphs).
-   **EE**: It allows for entering a three-dimensional incidence array, with each submatrix along the z-axis being a square incidence matrix. By default, `EE = NULL`.
-   **no.zeros:** For `no-zeros = TRUE`, the function omits zeros in the calculations. By default, `no-zeros = TRUE`.
-   **thr.cause**: Defines the degree of truth in which incidence is considered significant within the range $$0,1$$. By default, `thr = 0.5`.
-   **thr.effect**: Defines the degree of truth in which incidence is considered significant within the range $$0,1$$. By default, `thr = 0.5`.
-   **conf.level**: Defines the confidence level. By default, `conf.level = 0.95`.
-   **reps**: Defines the number of bootstrap replicates. By default, `reps = 10000`.
-   **delete**: Removes the non-significant results from the `$DirectEffects` set and returns the entered three-dimensional incidence arrays by assigning zeros to the edges whose incidences are significantly lower than `thr` at the p-value set in the `conf.level` parameter. By default, `delete = FALSE`.
-   **plot:** Generates a Dependence-Influence plot with the data from `$byCause` and `$byEffect`. The "Dependence" associated with `$byEffect` is on the X-axis, and the "Influence" associated with `$byCause` is on the Y-axis.

#### 

#### Example: Chained bipartite graphs

For example, to calculate the mean incidence of each cause and effect of the three-dimensional incidence arrays `CC`, `CE`, and `EE`, with the parameters `thr.cause = 0.5`, `thr.effect = 0.5`, `reps = 1000`, and `plot = TRUE`, we use the `bootMargin()` function.

``` r
result <- bootMargin(CC = CC, CE = CE, EE = EE, thr.cause = 0.5, thr.effect = 0.5, reps = 1000, plot = TRUE)
```

The results obtained are the data.frame `$byCause` and `$byEffect`, their values are:

``` r
result$byCause
#>    Var      Mean       LCI       UCI p.value
#> 1   I1 0.5296153 0.4862551 0.5754108   0.184
#> 2   I2 0.6320589 0.5839452 0.6823684   0.002
#> 3   I3 0.4779336 0.4190270 0.5366511   0.516
#> 4   I4 0.5281071 0.4651979 0.5793340   0.392
#> 5   I5 0.5619863 0.5124189 0.6120102   0.046
#> 6   I6 0.6008564 0.5350324 0.6617321   0.002
#> 7   I7 0.5865357 0.5250716 0.6465234   0.008
#> 8   I8 0.5808027 0.5198823 0.6434598   0.050
#> 9   I9 0.4895664 0.4326546 0.5471463   0.746
#> 10 I10 0.5304600 0.4606371 0.6043392   0.430
#> 11 I11 0.6739316 0.6090307 0.7408099   0.000
#> 12 I12 0.4925013 0.4427745 0.5451469   0.768
#> 13 I13 0.6262210 0.5346096 0.7150066   0.020
#> 14 I14 0.3121607 0.2749478 0.3514072   0.000
#> 15 I15 0.5238531 0.4818604 0.5654520   0.360
#> 16 I16 0.5587561 0.5095272 0.6045210   0.020
#> 17  B1 0.6770067 0.6000000 0.7250000   0.572
#> 18  B2 0.6824700 0.5700000 0.7950000   0.086
#> 19  B3 0.6779650 0.5500000 0.8350000   0.088
#> 20  B4 0.8086717 0.8000000 0.8200000   0.086
result$byEffect
#>    Var      Mean       LCI       UCI p.value
#> 1   I1 0.5082372 0.3960942 0.6166797   0.970
#> 2   I2 0.5635154 0.4520769 0.6686801   0.356
#> 3   I3 0.4446943 0.3409479 0.5524222   0.358
#> 4   I4 0.4896776 0.3646865 0.6149762   0.912
#> 5   I5 0.4859947 0.3919029 0.5710235   0.738
#> 6   I6 0.6146209 0.4837988 0.7201691   0.370
#> 7   I7 0.5690501 0.4573013 0.6719583   0.234
#> 8   I8 0.5891462 0.5254345 0.6545658   0.024
#> 9   I9 0.4616810 0.3607095 0.5680839   0.592
#> 10 I10 0.5028138 0.4032692 0.6110952   0.938
#> 11 I11 0.5935884 0.4546943 0.7122940   0.242
#> 12 I12 0.4751876 0.3626670 0.5840389   0.662
#> 13 I13 0.5683260 0.4965071 0.6360154   0.128
#> 14 I14 0.3452234 0.2357790 0.4567926   0.030
#> 15 I15 0.4833617 0.3662512 0.6013718   0.802
#> 16 I16 0.6235348 0.5474364 0.7089607   0.028
#> 17  B1 0.6113119 0.5168892 0.7050567   0.044
#> 18  B2 0.6995973 0.6432160 0.7685314   0.000
#> 19  B3 0.7048604 0.6470726 0.7705329   0.000
#> 20  B4 0.6535558 0.5697039 0.7541130   0.004
```

The parameter `plot = TRUE` generates the Dependency-Influence plane based on the results obtained.

``` r
result$plot
```

<img src="man/figures/README-unnamed-chunk-15-1.png" width="100%"/>

The parameter `delete = TRUE` eliminates the causes and effects whose average incidences are non-significant to the parameters `thr.cause` and `thr.effect` set.

``` r
result <- bootMargin(CC = CC, CE = CE, EE = EE, thr.cause = 0.5, thr.effect = 0.5, reps = 1000, plot = TRUE, delete = TRUE)
```

The variable I14 was removed from the new Dependence-Influence plane.

``` r
result$plot
```

<img src="man/figures/README-unnamed-chunk-17-1.png" width="100%"/>

Also, for `delete = TRUE`, the function returns the three-dimensional incidence matrices entered but removed non-significant causes and effects.

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

<img src="man/figures/README-unnamed-chunk-19-1.png" width="100%"/>

## centralitry()

The `centrality()` function calculates the median betweenness centrality, confidence intervals, and the selected method for calculating the centrality distribution for complete and chained bipartite graphs using multiple key informants.

The function returns an object of type data.frame that contains the following components:

-   **Var**: Name of the variable.
-   **Median**: Median calculated.
-   **LCI**: Lower Confidence Interval.
-   **UCI**: Upper Confidence Interval.
-   **Method**: Statistical method used associated with the model parameter.

### Parameters

-   **CC**: It allows for entering a three-dimensional incidence array, with each submatrix along the z-axis being a square incidence matrix. By default, `CC = NULL`.
-   **CE**: It allows for entering a three-dimensional incidence array, with each submatrix along the z-axis being a square incidence matrix (for complete graphs) or a rectangular matrix (for chained bipartite graphs).
-   **EE**: It allows for entering a three-dimensional incidence array, with each submatrix along the z-axis being a square incidence matrix. By default, `EE = NULL`.
-   **model:** Allows you to determine to which heavy-tailed distribution the entered variables correspond.
-   **conf.level**: Defines the confidence level. By default, `conf.level = 0.95`.
-   **reps**: Defines the number of bootstrap replicates. By default, `reps = 10000`.
-   **parallel:** Sets the type of parallel operation required. The options are "multicore", "snow", and "no". By default, `parallel = "no"`.
-   **ncpus:** Defines the number of cores to use. By default, `ncpus = 1`.

#### Example: Chained bipartite graphs

For example, to calculate the median betweenness centrality of each node of the three-dimensional incidence arrays `CC`, `CE`, and `EE`, with the parameters `model = "conpl"` and `reps = 100`, we use the `centrality()` function.

``` r
result <- centrality(CC = CC, CE = CE, EE = EE, model = "conpl", reps = 100)
```

The results obtained are:

``` r
result
#>    Var     Median        LCI       UCI Method pValue
#> 1   I1 14.5928488 12.6022381 20.224670  conpl   0.90
#> 2   I2 14.3563883  6.9951627 15.563849  conpl   0.69
#> 3   I3  8.1428571  1.1000000 14.100000 median     NA
#> 4   I4  0.6304530  0.1310204  1.398269  conpl   0.51
#> 5   I5  4.9851140  2.8491656  5.903125  conpl   0.23
#> 6   I6 13.5131265  5.7016027 32.346412  conpl   0.23
#> 7   I7 24.9878131  9.9123039 25.333211  conpl   0.69
#> 8   I8  5.0604244  1.6050496  7.027119  conpl   0.83
#> 9   I9  3.8250000  0.3839286  9.350000 median     NA
#> 10 I10  0.4667305  0.1264379  3.762587  conpl   0.11
#> 11 I11 21.2412358 13.2348815 21.849872  conpl   0.70
#> 12 I12  7.3106674  7.0038808  7.481355  conpl   0.74
#> 13 I13  2.3886553  0.5174001  4.153729  conpl   0.56
#> 14 I14  0.0000000  0.0000000  0.000000 median     NA
#> 15 I15  2.7760383  0.2023056  6.789980  conpl   0.89
#> 16 I16 10.0007456  3.7591790 12.886142  conpl   0.77
#> 17  B1  3.5000000  1.4166667  4.500000 median     NA
#> 18  B2  1.8957816  0.7127189  2.533421  conpl   0.40
#> 19  B3  0.8308252  0.3459435  1.494809  conpl   0.49
#> 20  B4  5.6666667  1.7333333  7.083333 median     NA
```

If any variable cannot be calculated with `model = "conpl"` it will be calculated with `model = "median"`.

#### Example: Complete graphs

Complete graphs only make use of the `CE` parameter. Here is an example:

``` r
result <- centrality(CE = CC, model = "median", reps = 500)
result
#>    Var    Median       LCI      UCI Method pValue
#> 1   I1 20.000000 7.1666667 41.50000 median     NA
#> 2   I2 14.500000 1.9159755 24.77778 median     NA
#> 3   I3  6.851190 0.3250000 12.58333 median     NA
#> 4   I4  2.079167 0.8333333 23.41667 median     NA
#> 5   I5  7.833333 0.3250000  9.00000 median     NA
#> 6   I6 28.391667 3.7118491 36.83333 median     NA
#> 7   I7 11.500000 2.0000000 41.33333 median     NA
#> 8   I8  7.416667 2.1666667 15.17738 median     NA
#> 9   I9  5.200000 3.1500000  5.20000 median     NA
#> 10 I10  4.250000 1.2500000 27.34524 median     NA
#> 11 I11 22.000000 2.5201044 30.75000 median     NA
#> 12 I12 12.516667 0.5000000 15.36667 median     NA
#> 13 I13  6.208333 2.0000000 12.37500 median     NA
#> 14 I14  0.000000 0.0000000  0.00000 median     NA
#> 15 I15  6.958333 2.0000000 22.70833 median     NA
#> 16 I16 16.166667 8.5769841 59.25000 median     NA
```

## FE()

The `FE()` function calculates the forgotten effects, the frequency of their occurrence, the mean incidence, the confidence intervals, and the standard error for complete and chained bipartite graphs using multiple key informants. This function implements bootstrap BCa.

The function returns two list-type objects. The first is `$boot`, which contains the following information:

-   **From**: Indicates the origin of the forgotten effects relationships.
-   **\$Through\_{x}\$**: Dynamic field that represents the intermediate relationships of the forgotten effects. For example, for order n there will be \$Through\_{1}\$ up to \$Through\_{n-1}\$.
-   **To**: Indicates the end of the forgotten effects relationships.
-   **Count**: Number of times the forgotten effect was repeated.
-   **Mean**: Mean effect of the forgotten effect
-   **LCI**: Lower Confidence Intervals.
-   **UCI**: Upper Confidence Intervals.
-   **SE**: Standard error.

And the second is `$byExpert`, which contains the following information:

-   **From**: Indicates the origin of the forgotten effects relationships.
-   $Through_{x}$: Dynamic field that represents the intermediate relationships of the forgotten effects. For example, for order n there will be $Through_{1}$ up to $Through_{n-1}$.
-   **To**: Indicates the end of the forgotten effects relationships.
-   **Count**: Number of times the forgotten effect was repeated.
-   $Expert_x$: Dynamic field that represents each of the entered experts.

### 

#### Parameters

-   **CC:** It allows for entering a three-dimensional incidence array, with each submatrix along the z-axis being a square incidence matrix. By default, `CC = NULL`.
-   **CE:** It allows for entering a three-dimensional incidence array, with each submatrix along the z-axis being a square incidence matrix (for complete graphs) or a rectangular matrix (for chained bipartite graphs).
-   **EE:** It allows for entering a three-dimensional incidence array, with each submatrix along the z-axis being a square incidence matrix. By default, `EE = NULL`.
-   **mode**: Specify the mode for the FE function. If the mode is set to 'Per-Expert,' the function will calculate using all experts. If the mode is set to 'Empirical,' the function will utilize this method.
-   **thr:** Defines the degree of truth in which incidence is considered significant within the range $[0,1]$. By default, `thr = 0.5`.
-   **maxOrder:** Defines the limit of forgotten effects to calculate (if they exist). By default, `maxOrder = 2`.
-   **reps:** Defines the number of bootstrap replicates. By default, `reps = 10000`.
-   **parallel:** Sets the type of parallel operation required. The options are "multicore", "snow", and "no". By default, `parallel = "no"`**.**
-   **ncpus:** Defines the number of cores to use. By default, `ncpus = 1`.

#### Example: Chained bipartite graphs

For example, to calculate the forgotten effects of three-dimensional incidence arrays `CC`, `CE`, and `EE`, with `thr = 0.5`, `maxOrder = 3`, and `reps = 1000`, we use the `FE()` function.

``` r
result <- FE(CC = CC, CE = CE, EE = EE, mode = 'Per-Expert', thr = 0.5, maxOrder = 3, reps = 1000)
#> Warning in FE_bootstrap(CC = CC, CE = CE, EE = EE, thr = thr, maxOrder =
#> maxOrder, : Expert number 7 has no 2nd maxOrder or higher effects.
```

The results are in the `$boot` list, which contains the forgotten effects sorted in order.

``` r
names(result$boot)
#> [1] "Order_2"
```

The results of the forgotten effects of the second order are:

``` r
head(result$boot$Order_2)
#>   From Through_1 To Count  Mean LCI   UCI         SE
#> 1   I1       I11 B1     2 0.800 0.6 0.800 0.13934999
#> 2   I8        I7 B1     2 0.725 0.6 0.725 0.08634788
#> 3  I14       I15 B2     2 0.725 0.7 0.725 0.01739963
#> 4  I10       I11 B3     2 0.600  NA    NA         NA
#> 5  I14       I15 B3     2 0.725 0.7 0.725 0.01726110
#> 6   I9        B3 B1     2 0.725 0.7 0.725 0.01763322
```

Any result containing an NA value in the LCI, UCI, and SE fields indicates that all incidences are the same or that the value is unique. Therefore, bootstrapping is not done.

The `$byExpert` list indicates in which expert the forgotten effect is generated.

#### 

#### Example: Complete graphs

When working with complete graphs, it is necessary to specify either the `CC` and `CE` parameters or the `CE` and `EE` parameters (as they are equivalent). Here is an example:

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
#> 1  I10     I11 I14   244 0.6616142 0.09212734
#> 2  I13     I16  I1   190 0.6219829 0.07313537
#> 3   I3      I6  I9   172 0.6539608 0.08288287
#> 4  I14     I11  I4   171 0.6708489 0.09223339
#> 5   I8     I13 I10   164 0.7036814 0.10011542
#> 6  I13     I11 I14   163 0.6714888 0.09672964
```

## References

1.  Kaufmann, A., & Gil Aluja, J. (1988). Modelos para la Investigación de efectos olvidados, Milladoiro. Santiago de Compostela, España.

2.  Manna, E. M., Rojas-Mora, J., & Mondaca-Marino, C. (2018). Application of the Forgotten Effects Theory for Assessing the Public Policy on Air Pollution of the Commune of Valdivia, Chile. In From Science to Society (pp. 61-72). Springer, Cham.

3.  Freeman, L.C. (1979). Centrality in Social Networks I: Conceptual Clarification. Social Networks, 1, 215-239.

4.  Ulrik Brandes, A Faster Algorithm for Betweenness Centrality. Journal of Mathematical Sociology 25(2):163-177, 2001.

5.  Canty A, Ripley BD (2021). boot: Bootstrap R (S-Plus) Functions. R package version 1.3-28.

6.  Davison AC, Hinkley DV (1997). Bootstrap Methods and Their Applications. Cambridge University Press, Cambridge. ISBN 0-521-57391-2, <http://statwww.epfl.ch/davison/BMA/>.

7.  Newman, M. E. (2005). Power laws, Pareto distributions and Zipf's law. Contemporary physics, 46(5), 323-351.

8.  Gillespie, C. S. (2014). Fitting heavy tailed distributions: the poweRlaw package. arXiv preprint arXiv:1407.3492.

9.  Kohl, M., & Kohl, M. M. (2020). Package 'MKinfer'.

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
