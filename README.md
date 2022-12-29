
<!-- README.md is generated from README.Rmd. Please edit that file -->

# foRgotten

<!-- badges: start -->
<!-- badges: end -->

## Description

The **foRgotten** library extends the theory of forgotten effects by
aggregating multiple key informants for complete and chained bipartite
graphs. 

The package allows for the following:

-   Calculation of the average incidence by edges for direct effects.
-   Calculation of the average incidence per cause and effect for direct
    effects.
-   Calculation of the median betweenness centrality per node for direct
    effects.
-   Calculation of the forgotten effects.
-   Use of complete graphs and chain bipartite graphs.

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

-   **From**: Origin of the incidence.
-   **To**: Destination of the incidence.
-   **Mean**: Average incidence.
-   **UCI**: Upper confidence interval.
-   **p.value**: Calculated p-value.

### Parameters

-   **CC**: It allows for entering a three-dimensional incidence array,
    with each submatrix along the z-axis being a square incidence
    matrix. By default, `CC = NULL`.
-   **CE**: It allows for entering a three-dimensional incidence array,
    with each submatrix along the z-axis being a square incidence matrix
    (for complete graphs) or a rectangular matrix (for chained bipartite
    graphs).
-   **EE**: It allows for entering a three-dimensional incidence array,
    with each submatrix along the z-axis being a square incidence
    matrix. By default, `EE = NULL`.
-   **thr**: Defines the degree of truth in which incidence is
    considered significant within the range \[0,1\]. By default,
    `thr = 0.5`.
-   **conf.level**: Defines the confidence level. By default,
    `conf.level = 0.95`.
-   **reps**: Defines the number of bootstrap replicates. By default,
    `reps = 10000`.
-   **delete**: Removes the non-significant results from the
    `$DirectEffects` set and returns the entered three-dimensional
    incidence arrays by assigning zeros to the edges whose incidences
    are significantly lower than `thr` at the p-value set in the
    `conf.level` parameter. By default, `delete = FALSE`.

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
#> 1    I1  I2 0.525 0.650   0.595
#> 2    I1  I3 0.450 0.575   0.281
#> 3    I1  I4 0.525 0.655   0.603
#> 4    I1  I5 0.465 0.640   0.370
#> 5    I1  I6 0.645 0.810   0.865
#> 6    I1  I7 0.815 0.870   1.000
#> 7    I1  I8 0.580 0.695   0.841
#> 8    I1  I9 0.490 0.635   0.449
#> 9    I1 I10 0.560 0.700   0.753
#> 10   I1 I11 0.525 0.695   0.594
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
#> 1    I1  I2 0.525 0.65000   0.594
#> 2    I1  I3 0.450 0.59000   0.297
#> 3    I1  I4 0.525 0.65500   0.617
#> 4    I1  I5 0.465 0.63025   0.372
#> 5    I1  I6 0.645 0.79500   0.872
#> 6    I1  I7 0.815 0.87000   1.000
#> 7    I1  I8 0.580 0.70000   0.850
#> 8    I1  I9 0.490 0.63000   0.475
#> 9    I1 I10 0.560 0.71000   0.728
#> 10   I1 I11 0.525 0.70000   0.585
```

## bootMargin()

The `bootMargin()` function calculates the mean incidence of each cause
and each effect, confidence intervals, and p-value for complete and
chained bipartite graphs using multiple key informants. This function
performs a t-test with bilateral contrast via bootstrap BCa.

The function returns a list object with the subset of data `$byCause`
and `$byEffect`, which includes the following information:

-   **Var**: Name of the variable.
-   **Mean**: Average incidence.
-   **LCI**: Lower confidence interval.
-   **UCI**: Upper confidence interval.
-   **p.value**: calculated p-value.

### Parameters

-   **CC**: It allows for entering a three-dimensional incidence array,
    with each submatrix along the z-axis being a square incidence
    matrix. By default, `CC = NULL`.
-   **CE**: It allows for entering a three-dimensional incidence array,
    with each submatrix along the z-axis being a square incidence matrix
    (for complete graphs) or a rectangular matrix (for chained bipartite
    graphs).
-   **EE**: It allows for entering a three-dimensional incidence array,
    with each submatrix along the z-axis being a square incidence
    matrix. By default, `EE = NULL`.
-   **no.zeros:** For `no-zeros = TRUE`, the function omits zeros in the
    calculations. By default, `no-zeros = TRUE`.
-   **thr.cause**: Defines the degree of truth in which incidence is
    considered significant within the range \[0,1\]. By default,
    `thr = 0.5`.
-   **thr.effect**: Defines the degree of truth in which incidence is
    considered significant within the range \[0,1\]. By default,
    `thr = 0.5`.
-   **conf.level**: Defines the confidence level. By default,
    `conf.level = 0.95`.
-   **reps**: Defines the number of bootstrap replicates. By default,
    `reps = 10000`.
-   **delete**: Removes the non-significant results from the
    `$DirectEffects` set and returns the entered three-dimensional
    incidence arrays by assigning zeros to the edges whose incidences
    are significantly lower than `thr` at the p-value set in the
    `conf.level` parameter. By default, `delete = FALSE`.
-   **plot:** Generates a Dependence-Influence plot with the data from
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
#> 1   I1 0.5353370 0.4929151 0.5796759   0.140
#> 2   I2 0.6259986 0.5760185 0.6774097   0.002
#> 3   I3 0.4692481 0.4097456 0.5268025   0.392
#> 4   I4 0.5257383 0.4621860 0.5895435   0.472
#> 5   I5 0.5604041 0.5101287 0.6119072   0.048
#> 6   I6 0.6002155 0.5319463 0.6692118   0.010
#> 7   I7 0.5855215 0.5310694 0.6478377   0.018
#> 8   I8 0.5796211 0.5107522 0.6410563   0.032
#> 9   I9 0.4907417 0.4354550 0.5487083   0.696
#> 10 I10 0.5299861 0.4609863 0.6071957   0.386
#> 11 I11 0.6715745 0.6042105 0.7392178   0.000
#> 12 I12 0.4912482 0.4394071 0.5461177   0.814
#> 13 I13 0.6276045 0.5361316 0.7155526   0.014
#> 14 I14 0.3115360 0.2756045 0.3477247   0.000
#> 15 I15 0.5226640 0.4802696 0.5619373   0.290
#> 16 I16 0.5579624 0.5137794 0.6030716   0.022
#> 17  B1 0.6795450 0.6000000 0.7250000   0.616
#> 18  B2 0.6794250 0.5700000 0.7950000   0.076
#> 19  B3 0.6736267 0.5500000 0.8350000   0.066
#> 20  B4 0.8083233 0.8000000 0.8200000   0.084
result$byEffect
#>    Var      Mean       LCI       UCI p.value
#> 1   I1 0.5026625 0.3768027 0.6160043   0.938
#> 2   I2 0.5624791 0.4515186 0.6697051   0.336
#> 3   I3 0.4444708 0.3447015 0.5491395   0.358
#> 4   I4 0.4907196 0.3690008 0.6134762   0.886
#> 5   I5 0.4819049 0.3883092 0.5688565   0.762
#> 6   I6 0.6092610 0.4769560 0.7166584   0.376
#> 7   I7 0.5692719 0.4619660 0.6684679   0.274
#> 8   I8 0.5895846 0.5247291 0.6525560   0.016
#> 9   I9 0.4632007 0.3607536 0.5720054   0.568
#> 10 I10 0.5037096 0.4012978 0.6013220   0.984
#> 11 I11 0.5903976 0.4534365 0.7188588   0.284
#> 12 I12 0.4707339 0.3495743 0.5866575   0.782
#> 13 I13 0.5673676 0.4918071 0.6369167   0.134
#> 14 I14 0.3446500 0.2392793 0.4610760   0.026
#> 15 I15 0.4852995 0.3560429 0.6013853   0.746
#> 16 I16 0.6229688 0.5407287 0.7114423   0.028
#> 17  B1 0.6223428 0.5322885 0.7195209   0.042
#> 18  B2 0.6964191 0.6417520 0.7619711   0.000
#> 19  B3 0.7091029 0.6519922 0.7728403   0.000
#> 20  B4 0.6583730 0.5772825 0.7405988   0.000
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

-   **Var**: Name of the variable.
-   **Median**: Median calculated.
-   **LCI**: Lower Confidence Interval.
-   **UCI**: Upper Confidence Interval.
-   **Method**: Statistical method used associated with the model
    parameter.

### Parameters

-   **CC**: It allows for entering a three-dimensional incidence array,
    with each submatrix along the z-axis being a square incidence
    matrix. By default, `CC = NULL`.
-   **CE**: It allows for entering a three-dimensional incidence array,
    with each submatrix along the z-axis being a square incidence matrix
    (for complete graphs) or a rectangular matrix (for chained bipartite
    graphs).
-   **EE**: It allows for entering a three-dimensional incidence array,
    with each submatrix along the z-axis being a square incidence
    matrix. By default, `EE = NULL`.
-   **model:** Allows you to determine to which heavy-tailed
    distribution the entered variables correspond.
-   **conf.level**: Defines the confidence level. By default,
    `conf.level = 0.95`.
-   **reps**: Defines the number of bootstrap replicates. By default,
    `reps = 10000`.
-   **parallel:** Sets the type of parallel operation required. The
    options are “multicore”, “snow”, and “no”. By default,
    `parallel = "no"`.
-   **ncpus:** Defines the number of cores to use. By default,
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
#> 1   I1 14.5928488  9.7956174 21.350585  conpl   0.87
#> 2   I2 14.3563883  6.9669664 15.982455  conpl   0.72
#> 3   I3  8.1428571  1.1000000 14.100000 median     NA
#> 4   I4  0.6304530  0.1381803  1.410466  conpl   0.44
#> 5   I5  4.9851140  0.7488343  5.996145  conpl   0.34
#> 6   I6 13.5131265  0.8248384 32.420736  conpl   0.22
#> 7   I7 24.9878131  9.5127431 25.683050  conpl   0.64
#> 8   I8  5.0604244  1.5941137 10.129009  conpl   0.77
#> 9   I9  2.2542738  0.2065006  2.657844  conpl   0.78
#> 10 I10  0.4667305  0.1295650  3.731656  conpl   0.10
#> 11 I11 21.2412358 10.5239979 21.849872  conpl   0.68
#> 12 I12  7.3106674  7.0809045  7.481355  conpl   0.80
#> 13 I13  2.3886553  0.5067284  4.512930  conpl   0.60
#> 14 I14  0.0000000  0.0000000  0.000000 median     NA
#> 15 I15  2.7760383  0.2018116  6.610533  conpl   0.83
#> 16 I16 10.0007456  3.4395567 13.039134  conpl   0.70
#> 17  B1  3.5000000  1.4166667 14.600000 median     NA
#> 18  B2  1.8957816  0.6643364  2.535891  conpl   0.42
#> 19  B3  0.8308252  0.3514284  1.493158  conpl   0.35
#> 20  B4  3.4524972  0.7493693  4.351237  conpl   0.89
```

If any variable cannot be calculated with `model = "conpl"` it will be
calculated with `model = "median"`.

#### Example: Complete graphs

Complete graphs only make use of the `CE` parameter. Here is an example:

``` r
result <- centrality(CE = CC, model = "median", reps = 500)
result
#>    Var    Median       LCI      UCI Method pValue
#> 1   I1 20.000000 7.1666667 41.50000 median     NA
#> 2   I2 14.500000 2.5000000 24.77778 median     NA
#> 3   I3  6.851190 0.3250000 12.58333 median     NA
#> 4   I4  2.079167 0.8333333 23.41667 median     NA
#> 5   I5  7.833333 0.6666667  9.00000 median     NA
#> 6   I6 28.391667 8.3380952 36.83333 median     NA
#> 7   I7 11.500000 2.0000000 41.33333 median     NA
#> 8   I8  7.416667 2.1666667 15.17738 median     NA
#> 9   I9  5.200000 3.1500000 13.50000 median     NA
#> 10 I10  4.250000 1.2500000 12.00000 median     NA
#> 11 I11 22.000000 3.6311884 30.75000 median     NA
#> 12 I12 12.516667 0.5000000 15.36667 median     NA
#> 13 I13  6.208333 2.0000000 12.37500 median     NA
#> 14 I14  0.000000 0.0000000  0.00000      0     NA
#> 15 I15  6.958333 2.0000000 51.60417 median     NA
#> 16 I16 16.166667 8.5769841 43.85417 median     NA
```

## FE()

The `FE()` function calculates the forgotten effects, the frequency of
their occurrence, the mean incidence, the confidence intervals, and the
standard error for complete and chained bipartite graphs using multiple
key informants. This function implements bootstrap BCa.

The function returns two list-type objects. The first is `$boot`, which
contains the following information:

-   **From**: Indicates the origin of the forgotten effects
    relationships.
-   **\$Through\_{x}\$**: Dynamic field that represents the intermediate
    relationships of the forgotten effects. For example, for order n
    there will be \$Though\_{1}\$ up to \$Though\_{n-1}\$.
-   **To**: Indicates the end of the forgotten effects relationships.
-   **Count**: Number of times the forgotten effect was repeated.
-   **Mean**: Mean effect of the forgotten effect
-   **LCI**: Lower Confidence Intervals.
-   **UCI**: Upper Confidence Intervals.
-   **SE**: Standard error.

And the second is `$byExpert`, which contains the following information:

-   **From**: Indicates the origin of the forgotten effects
    relationships.
-   $Through_{x}$: Dynamic field that represents the intermediate
    relationships of the forgotten effects. For example, for order n
    there will be $Though_{1}$ up to $Though_{n-1}$.
-   **To**: Indicates the end of the forgotten effects relationships.
-   **Count**: Number of times the forgotten effect was repeated.
-   $Expert_x$: Dynamic field that represents each of the entered
    experts.

### 

#### Parameters

-   **CC:** It allows for entering a three-dimensional incidence array,
    with each submatrix along the z-axis being a square incidence
    matrix. By default, `CC = NULL`.
-   **CE:** It allows for entering a three-dimensional incidence array,
    with each submatrix along the z-axis being a square incidence matrix
    (for complete graphs) or a rectangular matrix (for chained bipartite
    graphs).
-   **EE:** It allows for entering a three-dimensional incidence array,
    with each submatrix along the z-axis being a square incidence
    matrix. By default, `EE = NULL`.
-   **thr:** Defines the degree of truth in which incidence is
    considered significant within the range \[0,1\]. By default,
    `thr = 0.5`.
-   **maxOrder:** Defines the limit of forgotten effects to calculate
    (if they exist). By default, `maxOrder = 2`.
-   **reps:** Defines the number of bootstrap replicates. By default,
    `reps = 10000`.
-   **parallel:** Sets the type of parallel operation required. The
    options are “multicore”, “snow”, and “no”. By default,
    `parallel = "no"`**.**
-   **ncpus:** Defines the number of cores to use. By default,
    `ncpus = 1`.

#### Example: Chained bipartite graphs

For example, to calculate the forgotten effects of three-dimensional
incidence arrays `CC`, `CE`, and `EE`, with `thr = 0.5`, `maxOrder = 3`,
and `reps = 1000`, we use the `FE()` function.

``` r
result <- FE(CC = CC, CE = CE, EE = EE, thr = 0.5, maxOrder = 3, reps = 1000)
#> Warning in wrapper.FE(CC = CC, CE = CE, EE = EE, thr = thr, maxOrder =
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
#> 1   I1       I11 B1     2 0.800 0.6 1.000 0.14398087
#> 2   I8        I7 B1     2 0.725 0.6 0.725 0.08980423
#> 3  I14       I15 B2     2 0.725 0.7 0.725 0.01775649
#> 4  I10       I11 B3     2 0.600  NA    NA         NA
#> 5  I14       I15 B3     2 0.725 0.7 0.725 0.01762555
#> 6   I9        B3 B1     2 0.725 0.7 0.725 0.01763251
```

Any result containing an NA value in the LCI, UCI, and SE fields
indicates that all incidences are the same or that the value is unique.
Therefore, bootstrapping is not done.

The `$byExpert` list indicates in which expert the forgotten effect is
generated.

#### 

#### Example: Complete graphs

Complete graphs only make use of the `CE` parameter. Here is an example:

``` r
result <- FE(CE = CC, thr = 0.5, maxOrder = 3, reps = 1000)
head(result$boot$Order_2)
#>   From Through_1  To Count      Mean    LCI       UCI         SE
#> 1   I8       I11 I10     4 0.6125000 0.5625 0.6615477 0.02690548
#> 2   I5       I11 I10     3 0.6166667 0.5500 0.6666667 0.03562165
#> 3   I6       I11 I14     3 0.6833333 0.6000 0.7666667 0.07088501
#> 4  I13       I11 I14     3 0.5833333 0.5500 0.5833333 0.01327800
#> 5  I13        I6  I1     3 0.6333333 0.6000 0.6666667 0.02542234
#> 6  I13       I16  I1     3 0.6333333 0.6000 0.6666667 0.02747491
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
