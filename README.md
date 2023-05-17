---
editor_options: 
  markdown: 
    wrap: 72
---

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
`CE`, and `EE`. The data are those used in the study "Application of the
Forgotten Effects Theory For Assessing the Public Policy on Air
Pollution Of the Commune of Valdivia, Chile" developed by Manna, E. M et
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
    considered significant within the range $$0,1$$. By default,
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
#>    From  To  Mean     UCI p.value
#> 1    I1  I2 0.525 0.65500   0.590
#> 2    I1  I3 0.450 0.60000   0.281
#> 3    I1  I4 0.525 0.66000   0.624
#> 4    I1  I5 0.465 0.65500   0.367
#> 5    I1  I6 0.645 0.79525   0.879
#> 6    I1  I7 0.815 0.87000   1.000
#> 7    I1  I8 0.580 0.69500   0.837
#> 8    I1  I9 0.490 0.64000   0.464
#> 9    I1 I10 0.560 0.70525   0.729
#> 10   I1 I11 0.525 0.69000   0.571
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
#> 1    I1  I2 0.525 0.65000   0.604
#> 2    I1  I3 0.450 0.59525   0.286
#> 3    I1  I4 0.525 0.67000   0.619
#> 4    I1  I5 0.465 0.64500   0.383
#> 5    I1  I6 0.645 0.80500   0.869
#> 6    I1  I7 0.815 0.87500   1.000
#> 7    I1  I8 0.580 0.70000   0.847
#> 8    I1  I9 0.490 0.63500   0.449
#> 9    I1 I10 0.560 0.70525   0.722
#> 10   I1 I11 0.525 0.69500   0.589
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
    considered significant within the range $$0,1$$. By default,
    `thr = 0.5`.
-   **thr.effect**: Defines the degree of truth in which incidence is
    considered significant within the range $$0,1$$. By default,
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
    `$byCause` and `$byEffect`. The "Dependence" associated with
    `$byEffect` is on the X-axis, and the "Influence" associated with
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
#> 1   I1 0.5348260 0.4890640 0.5766682   0.138
#> 2   I2 0.6242440 0.5708310 0.6704769   0.000
#> 3   I3 0.4692691 0.4077288 0.5306179   0.366
#> 4   I4 0.5277707 0.4646046 0.5886836   0.494
#> 5   I5 0.5620892 0.5074846 0.6143655   0.050
#> 6   I6 0.5995631 0.5274699 0.6697688   0.014
#> 7   I7 0.5873125 0.5309189 0.6460417   0.008
#> 8   I8 0.5784057 0.5177251 0.6379254   0.036
#> 9   I9 0.4903835 0.4315024 0.5472880   0.696
#> 10 I10 0.5323750 0.4608300 0.6009315   0.406
#> 11 I11 0.6736042 0.6106075 0.7421155   0.000
#> 12 I12 0.4905313 0.4413286 0.5440046   0.822
#> 13 I13 0.6263934 0.5371689 0.7149145   0.016
#> 14 I14 0.3129677 0.2723672 0.3497751   0.000
#> 15 I15 0.5224982 0.4787364 0.5618078   0.294
#> 16 I16 0.5599447 0.5145161 0.6064825   0.034
#> 17  B1 0.6792550 0.6000000 0.7250000   0.622
#> 18  B2 0.6823000 0.5700000 0.7950000   0.096
#> 19  B3 0.6750200 0.5500000 0.8350000   0.062
#> 20  B4 0.8083333 0.8000000 0.8200000   0.076
result$byEffect
#>    Var      Mean       LCI       UCI p.value
#> 1   I1 0.5022324 0.3919363 0.6113811   0.930
#> 2   I2 0.5606192 0.4511417 0.6645417   0.346
#> 3   I3 0.4440015 0.3411715 0.5532302   0.324
#> 4   I4 0.4952096 0.3821044 0.6229298   0.852
#> 5   I5 0.4851443 0.3799619 0.5697214   0.698
#> 6   I6 0.6131504 0.4836782 0.7185508   0.374
#> 7   I7 0.5725031 0.4652468 0.6708981   0.264
#> 8   I8 0.5887837 0.5247833 0.6524646   0.024
#> 9   I9 0.4602504 0.3573560 0.5776054   0.648
#> 10 I10 0.4997504 0.4044208 0.6031637   0.888
#> 11 I11 0.5913535 0.4499234 0.7252592   0.240
#> 12 I12 0.4731011 0.3594159 0.5941472   0.724
#> 13 I13 0.5679242 0.4929795 0.6376237   0.122
#> 14 I14 0.3428364 0.2298274 0.4562339   0.040
#> 15 I15 0.4830725 0.3566226 0.6081043   0.792
#> 16 I16 0.6209712 0.5399833 0.7038132   0.008
#> 17  B1 0.6211837 0.5325076 0.7142570   0.038
#> 18  B2 0.6957081 0.6357878 0.7649920   0.000
#> 19  B3 0.7078423 0.6543755 0.7698374   0.000
#> 20  B4 0.6600633 0.5820641 0.7455971   0.006
```

The parameter `plot = TRUE` generates the Dependency-Influence plane
based on the results obtained.

``` r
result$plot
```

<img src="man/figures/README-unnamed-chunk-15-1.png" width="100%"/>

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

<img src="man/figures/README-unnamed-chunk-17-1.png" width="100%"/>

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

<img src="man/figures/README-unnamed-chunk-19-1.png" width="100%"/>

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
    options are "multicore", "snow", and "no". By default,
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
#> 1   I1 14.5928488  5.7027296 21.077057  conpl   0.90
#> 2   I2 14.3563883  7.2006417 15.563849  conpl   0.76
#> 3   I3  8.1428571  1.1000000 13.193486 median     NA
#> 4   I4  0.6304530  0.1268614  1.256204  conpl   0.48
#> 5   I5  4.9851140  4.3084551  5.835371  conpl   0.32
#> 6   I6 13.5131265  5.6671220 32.179891  conpl   0.19
#> 7   I7 24.9878131 17.4787983 25.333211  conpl   0.67
#> 8   I8  5.0604244  1.6559433  6.905017  conpl   0.87
#> 9   I9  3.8250000  0.3923263 11.136738 median     NA
#> 10 I10  0.4667305  0.1308994  3.929054  conpl   0.10
#> 11 I11 21.2412358  9.7077813 21.599264  conpl   0.69
#> 12 I12  7.3106674  2.9355707  7.558573  conpl   0.79
#> 13 I13  2.3886553  0.5447938  3.964018  conpl   0.46
#> 14 I14  0.0000000  0.0000000  0.000000 median     NA
#> 15 I15  2.7760383  0.2001746  6.610533  conpl   0.77
#> 16 I16 10.0007456  3.5596928 13.682491  conpl   0.80
#> 17  B1  3.5000000  1.4166667  4.500000 median     NA
#> 18  B2  1.8957816  0.7758066  2.296492  conpl   0.34
#> 19  B3  0.8308252  0.3377657  1.454149  conpl   0.43
#> 20  B4  3.4524972  0.7573743  4.170746  conpl   0.94
```

If any variable cannot be calculated with `model = "conpl"` it will be
calculated with `model = "median"`.

#### Example: Complete graphs

Complete graphs only make use of the `CE` parameter. Here is an example:

``` r
result <- centrality(CE = CC, model = "median", reps = 500)
result
#>    Var    Median       LCI       UCI Method pValue
#> 1   I1 20.000000 7.2374464 41.500000 median     NA
#> 2   I2 14.500000 2.0899208 24.777778 median     NA
#> 3   I3  6.851190 0.3250000 12.583333 median     NA
#> 4   I4  2.079167 0.8333333 21.583333 median     NA
#> 5   I5  7.833333 0.3250000  8.333333 median     NA
#> 6   I6 28.391667 8.3380952 36.833333 median     NA
#> 7   I7 11.500000 1.6516462 41.333333 median     NA
#> 8   I8  7.416667 2.1666667 15.177381 median     NA
#> 9   I9  5.200000 3.1500000 13.500000 median     NA
#> 10 I10  4.250000 1.3858543 27.345238 median     NA
#> 11 I11 22.000000 3.8256416 30.750000 median     NA
#> 12 I12 12.516667 0.5000000 15.366667 median     NA
#> 13 I13  6.208333 2.0000000 12.375000 median     NA
#> 14 I14  0.000000 0.0000000  0.000000      0     NA
#> 15 I15  6.958333 2.0000000 51.604167 median     NA
#> 16 I16 16.166667 8.5769841 43.854167 median     NA
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
    considered significant within the range $$0,1$$. By default,
    `thr = 0.5`.
-   **maxOrder:** Defines the limit of forgotten effects to calculate
    (if they exist). By default, `maxOrder = 2`.
-   **reps:** Defines the number of bootstrap replicates. By default,
    `reps = 10000`.
-   **parallel:** Sets the type of parallel operation required. The
    options are "multicore", "snow", and "no". By default,
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
#> 1   I1       I11 B1     2 0.800 0.6 0.800 0.14022719
#> 2   I8        I7 B1     2 0.725 0.6 0.725 0.08690101
#> 3  I14       I15 B2     2 0.725 0.7 0.750 0.01798257
#> 4  I10       I11 B3     2 0.600  NA    NA         NA
#> 5  I14       I15 B3     2 0.725 0.7 0.725 0.01779119
#> 6   I9        B3 B1     2 0.725 0.7 0.725 0.01780987
```

Any result containing an NA value in the LCI, UCI, and SE fields
indicates that all incidences are the same or that the value is unique.
Therefore, bootstrapping is not done.

The `$byExpert` list indicates in which expert the forgotten effect is
generated.

#### 

#### Example: Complete graphs

For complete graphs you need to use the parameters \`CC\` and \`CE\` or
the parameters \`CE\` and \`EE\`. This depends on your data. Here is an
example:

``` r
result <- directEffects(CC = CC, CE = CC, mode = 'Per-Expert',thr = 0.5, reps = 1000)
head(result$boot$Order_2)
#>   From Through_1  To Count      Mean    LCI       UCI         SE
#> 1   I8       I11 I10     4 0.6125000 0.5625 0.6500000 0.02690025
#> 2   I5       I11 I10     3 0.6166667 0.5500 0.6906074 0.03643012
#> 3   I6       I11 I14     3 0.6833333 0.6000 0.7666667 0.06684738
#> 4  I13       I11 I14     3 0.5833333 0.5500 0.6000000 0.01388883
#> 5  I13        I6  I1     3 0.6333333 0.6000 0.6666667 0.02733228
#> 6  I13       I16  I1     3 0.6333333 0.6000 0.6666667 0.02743940
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

7.  Newman, M. E. (2005). Power laws, Pareto distributions and Zipf's
    law. Contemporary physics, 46(5), 323-351.

8.  Gillespie, C. S. (2014). Fitting heavy tailed distributions: the
    poweRlaw package. arXiv preprint arXiv:1407.3492.

9.  Kohl, M., & Kohl, M. M. (2020). Package 'MKinfer'.

## Citation

``` r
citation("foRgotten")
#> 
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
