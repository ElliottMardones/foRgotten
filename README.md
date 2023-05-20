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
#> 1    I1  I2 0.525 0.65000   0.613
#> 2    I1  I3 0.450 0.58500   0.319
#> 3    I1  I4 0.525 0.66000   0.622
#> 4    I1  I5 0.465 0.63500   0.379
#> 5    I1  I6 0.645 0.80500   0.861
#> 6    I1  I7 0.815 0.87000   1.000
#> 7    I1  I8 0.580 0.69000   0.856
#> 8    I1  I9 0.490 0.64000   0.467
#> 9    I1 I10 0.560 0.71025   0.751
#> 10   I1 I11 0.525 0.69500   0.584
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
#>    From  To  Mean   UCI p.value
#> 1    I1  I2 0.525 0.650   0.619
#> 2    I1  I3 0.450 0.595   0.320
#> 3    I1  I4 0.525 0.655   0.613
#> 4    I1  I5 0.465 0.640   0.362
#> 5    I1  I6 0.645 0.810   0.875
#> 6    I1  I7 0.815 0.875   1.000
#> 7    I1  I8 0.580 0.695   0.829
#> 8    I1  I9 0.490 0.645   0.459
#> 9    I1 I10 0.560 0.705   0.731
#> 10   I1 I11 0.525 0.690   0.593
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
#> 1   I1 0.5298835 0.4873077 0.5729064   0.206
#> 2   I2 0.6330834 0.5828925 0.6794759   0.000
#> 3   I3 0.4770524 0.4169472 0.5344554   0.518
#> 4   I4 0.5279723 0.4687206 0.5854229   0.404
#> 5   I5 0.5614070 0.5072646 0.6134444   0.056
#> 6   I6 0.6016456 0.5325409 0.6687796   0.024
#> 7   I7 0.5853354 0.5284503 0.6479247   0.012
#> 8   I8 0.5791373 0.5115482 0.6435753   0.054
#> 9   I9 0.4908606 0.4330477 0.5495088   0.670
#> 10 I10 0.5302450 0.4583867 0.5999282   0.404
#> 11 I11 0.6735549 0.6078158 0.7419006   0.000
#> 12 I12 0.4925269 0.4391722 0.5458161   0.732
#> 13 I13 0.6250923 0.5375921 0.7131689   0.020
#> 14 I14 0.3119004 0.2728121 0.3516346   0.000
#> 15 I15 0.5232475 0.4786997 0.5665680   0.306
#> 16 I16 0.5593589 0.5164550 0.6070651   0.034
#> 17  B1 0.6787567 0.6000000 0.7250000   0.592
#> 18  B2 0.6791900 0.5700000 0.7950000   0.058
#> 19  B3 0.6747667 0.5500000 0.8350000   0.062
#> 20  B4 0.8082400 0.8000000 0.8200000   0.076
result$byEffect
#>    Var      Mean       LCI       UCI p.value
#> 1   I1 0.5033065 0.3945180 0.6158436   0.896
#> 2   I2 0.5624161 0.4512718 0.6680333   0.350
#> 3   I3 0.4453445 0.3443170 0.5465340   0.338
#> 4   I4 0.4893262 0.3614544 0.6190486   0.888
#> 5   I5 0.4859450 0.3914812 0.5780506   0.734
#> 6   I6 0.6151927 0.4841452 0.7160506   0.358
#> 7   I7 0.5705967 0.4600705 0.6732417   0.276
#> 8   I8 0.5893209 0.5219982 0.6577312   0.024
#> 9   I9 0.4666999 0.3576875 0.5764869   0.528
#> 10 I10 0.5055642 0.4094843 0.6130988   0.984
#> 11 I11 0.5992489 0.4577890 0.7260888   0.296
#> 12 I12 0.4748629 0.3532333 0.5877298   0.680
#> 13 I13 0.5684225 0.4958404 0.6410167   0.120
#> 14 I14 0.3441729 0.2268722 0.4518459   0.046
#> 15 I15 0.4821794 0.3621143 0.6056737   0.828
#> 16 I16 0.6226870 0.5404232 0.7095742   0.024
#> 17  B1 0.6143246 0.5224696 0.7116300   0.046
#> 18  B2 0.6998361 0.6431936 0.7643347   0.000
#> 19  B3 0.7041616 0.6458357 0.7747451   0.000
#> 20  B4 0.6524690 0.5691958 0.7453475   0.002
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
#> 1   I1 14.5928488 12.4928851 20.576565  conpl   0.97
#> 2   I2 14.3563883  6.6153607 15.427170  conpl   0.65
#> 3   I3  8.1428571  1.1000000 14.100000 median     NA
#> 4   I4  0.6304530  0.1337368  2.910715  conpl   0.45
#> 5   I5  4.9851140  2.9318518  5.941286  conpl   0.24
#> 6   I6 13.5131265  5.8616250 31.937296  conpl   0.22
#> 7   I7 24.9878131 19.8143301 25.683050  conpl   0.60
#> 8   I8  5.0604244  1.6244802  6.777587  conpl   0.85
#> 9   I9  2.2542738  0.2081032  2.711198  conpl   0.80
#> 10 I10  0.4667305  0.1283341  3.932180  conpl   0.19
#> 11 I11 21.2412358 15.5818361 21.623792  conpl   0.69
#> 12 I12  7.3106674  3.0486692  7.612816  conpl   0.75
#> 13 I13  2.3886553  0.5300378  9.334741  conpl   0.49
#> 14 I14  0.0000000  0.0000000  0.000000 median     NA
#> 15 I15  2.7760383  0.2033357  6.581992  conpl   0.81
#> 16 I16 10.0007456  3.7618868 14.994930  conpl   0.74
#> 17  B1  3.5000000  1.4166667 14.600000 median     NA
#> 18  B2  1.8957816  0.7085054  2.321229  conpl   0.45
#> 19  B3  0.8308252  0.3613726  1.469746  conpl   0.41
#> 20  B4  3.4524972  0.7406074  4.232574  conpl   0.90
```

If any variable cannot be calculated with `model = "conpl"` it will be calculated with `model = "median"`.

#### Example: Complete graphs

Complete graphs only make use of the `CE` parameter. Here is an example:

``` r
result <- centrality(CE = CC, model = "median", reps = 500)
result
#>    Var    Median       LCI      UCI Method pValue
#> 1   I1 20.000000 7.1666667 41.50000 median     NA
#> 2   I2 14.500000 2.3899050 24.77778 median     NA
#> 3   I3  6.851190 0.3250000 12.58333 median     NA
#> 4   I4  2.079167 0.8333333 21.58333 median     NA
#> 5   I5  7.833333 0.5500723  9.00000 median     NA
#> 6   I6 28.391667 8.3380952 36.83333 median     NA
#> 7   I7 11.500000 2.0000000 41.33333 median     NA
#> 8   I8  7.416667 1.3569666 15.17738 median     NA
#> 9   I9  5.200000 3.1500000 13.50000 median     NA
#> 10 I10  4.250000 1.2500000 12.00000 median     NA
#> 11 I11 22.000000 4.3333333 30.75000 median     NA
#> 12 I12 12.516667 0.5000000 15.36667 median     NA
#> 13 I13  6.208333 2.0000000 12.37500 median     NA
#> 14 I14  0.000000 0.0000000  0.00000 median     NA
#> 15 I15  6.958333 2.0000000 44.45833 median     NA
#> 16 I16 16.166667 8.5769841 43.85417 median     NA
```

## FE()

The `FE()` function calculates the forgotten effects, the frequency of their occurrence, the mean incidence, the confidence intervals, and the standard error for complete and chained bipartite graphs using multiple key informants. This function implements bootstrap BCa.

The function returns two list-type objects. The first is `$boot`, which contains the following information:

-   **From**: Indicates the origin of the forgotten effects relationships.
-   **\$Through\_{x}\$**: Dynamic field that represents the intermediate relationships of the forgotten effects. For example, for order n there will be \$Though\_{1}\$ up to \$Though\_{n-1}\$.
-   **To**: Indicates the end of the forgotten effects relationships.
-   **Count**: Number of times the forgotten effect was repeated.
-   **Mean**: Mean effect of the forgotten effect
-   **LCI**: Lower Confidence Intervals.
-   **UCI**: Upper Confidence Intervals.
-   **SE**: Standard error.

And the second is `$byExpert`, which contains the following information:

-   **From**: Indicates the origin of the forgotten effects relationships.
-   $Through_{x}$: Dynamic field that represents the intermediate relationships of the forgotten effects. For example, for order n there will be $Though_{1}$ up to $Though_{n-1}$.
-   **To**: Indicates the end of the forgotten effects relationships.
-   **Count**: Number of times the forgotten effect was repeated.
-   $Expert_x$: Dynamic field that represents each of the entered experts.

### 

#### Parameters

-   **CC:** It allows for entering a three-dimensional incidence array, with each submatrix along the z-axis being a square incidence matrix. By default, `CC = NULL`.
-   **CE:** It allows for entering a three-dimensional incidence array, with each submatrix along the z-axis being a square incidence matrix (for complete graphs) or a rectangular matrix (for chained bipartite graphs).
-   **EE:** It allows for entering a three-dimensional incidence array, with each submatrix along the z-axis being a square incidence matrix. By default, `EE = NULL`.
-   **mode**: Specify the mode for the FE function. If the mode is set to 'Per-Expert,' the function will calculate using all experts. If the mode is set to 'Empirical,' the function will utilize this method. 
-   **thr:** Defines the degree of truth in which incidence is considered significant within the range $$0,1$$. By default, `thr = 0.5`.
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
#> 1   I1       I11 B1     2 0.800 0.6 0.800 0.14006948
#> 2   I8        I7 B1     2 0.725 0.6 0.725 0.08524818
#> 3  I14       I15 B2     2 0.725 0.7 0.725 0.01749086
#> 4  I10       I11 B3     2 0.600  NA    NA         NA
#> 5  I14       I15 B3     2 0.725 0.7 0.750 0.01791411
#> 6   I9        B3 B1     2 0.725 0.7 0.725 0.01739771
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
#> 1  I10     I11 I14   211 0.6554004 0.08749096
#> 2   I3      I6  I9   195 0.6414121 0.08521618
#> 3   I8     I13 I10   193 0.7059817 0.10755392
#> 4  I13      I6  I9   178 0.6580029 0.09083844
#> 5  I14     I11  I4   178 0.6592578 0.09740236
#> 6   I9      I8 I13   164 0.6812431 0.09688230
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
