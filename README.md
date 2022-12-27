
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
confidence interval, and p-value for complete and chained bipartite
graphs using multiple key informants. This function performs a t-test
with left one-sided contrast via bootstrap BCa.

The function returns a list object with the subset of data
`$DirectEffects` that includes the following information:

-   From: Origin of the incidence.
-   To: Destination of the incidence.
-   Mean: Average incidence.
-   UCI: Upper confidence interval.
-   p.value: Calculated p-value.

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
    are significantly lower than thr at the p-value set in the
    `conf.level` parameter. By default, `delete = FALSE`.

#### Example: Complete Graphs

For complete graphs, only the `CE` parameter is used. For example:

``` r
result <- directEffects( CE = CC, thr = 0.5, reps = 1000)
```

The results obtained correspond to 240 first-order incidences. The first
six values are:

``` r
head(result$DirectEffects)
#>   From To  Mean   UCI p.value
#> 1   I1 I2 0.525 0.655   0.587
#> 2   I1 I3 0.450 0.585   0.320
#> 3   I1 I4 0.525 0.665   0.619
#> 4   I1 I5 0.465 0.635   0.381
#> 5   I1 I6 0.645 0.810   0.868
#> 6   I1 I7 0.815 0.875   1.000
```

Any result that contains an NA value in the UCI and p.value fields
indicates that all incidences are equal or that the value is unique.
Therefore, no bootstrapping is performed.

The parameter `delete = TRUE` removes non-significant incidents. For
example:

``` r
result <- directEffects( CE = CC, thr = 0.5, reps = 1000, delete = TRUE)
#> deleting data...
```

The number of significant incidences decreased from 240 to 217. For
`delete = TRUE`, the function returns the entered three-dimensional
incidence array but assigns zero to the non-significant edges.

#### Example: Chained bipartite graphs

The `CC`, `CE`, and `EE` parameters are used for chained bipartite
graphs. The other parameters maintain their functionality except for the
`delete` parameter, which now returns the three entered
three-dimensional incidence arrays but assigns zero to the
non-significant edges.

``` r
result <- directEffects( CC = CC, CE = CE, EE = EE, thr = 0.5, reps = 1000, delete = TRUE)
#> deleting data...
#> deleting data...
#> There is no data to delete...
names(result)
#> [1] "CC"            "CE"            "EE"            "DirectEffects"
```

### bootMargin()

The `bootMargin()` function calculates the mean incidence of each cause
and each effect, confidence intervals, and p-value for complete and
chained bipartite graphs using multiple key informants. This function
performs a t-test with bilateral contrast via bootstrap BCa.

The function returns a list object with the subset of data `$byCause`
and `$byEffect`, which includes the following information:

-   Var: Name of the variable.

-   Mean: Average incidence.

-   LCI: Lower confidence interval.

-   UCI: Upper confidence interval.

-   p.value: calculated p-value.

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

#### Example: Complete Graphs

For complete graphs, only the `CE` parameter is used. For example:

``` r
result <- bootMargin( CE = CC, thr.cause = 0.5, thr.effect = 0.5, reps = 1000)
```

The results are:

``` r
result$byCause
#>    Var      Mean       LCI       UCI p.value
#> 1   I1 0.5361074 0.4799528 0.5943500   0.248
#> 2   I2 0.6037840 0.5508833 0.6553389   0.002
#> 3   I3 0.4386533 0.3851188 0.4894924   0.014
#> 4   I4 0.4995099 0.4363028 0.5529426   0.994
#> 5   I5 0.5491052 0.4914324 0.6100389   0.148
#> 6   I6 0.5577080 0.4933324 0.6222333   0.134
#> 7   I7 0.5382447 0.4901028 0.5890231   0.160
#> 8   I8 0.5474007 0.4793704 0.6099324   0.210
#> 9   I9 0.4688709 0.4070389 0.5269333   0.292
#> 10 I10 0.4932108 0.4222954 0.5613435   0.802
#> 11 I11 0.6102947 0.5643565 0.6623380   0.002
#> 12 I12 0.4688296 0.4183437 0.5145213   0.258
#> 13 I13 0.5573677 0.4732083 0.6402333   0.202
#> 14 I14 0.3269370 0.2868803 0.3653884   0.000
#> 15 I15 0.5016655 0.4572932 0.5512369   0.914
#> 16 I16 0.5370107 0.4880917 0.5876713   0.184
```

``` r
result$byEffect
#>    Var      Mean       LCI       UCI p.value
#> 1   I1 0.5038559 0.3877680 0.6213438   0.910
#> 2   I2 0.5614833 0.4462788 0.6680167   0.354
#> 3   I3 0.4453305 0.3419870 0.5497582   0.356
#> 4   I4 0.4890874 0.3672171 0.6061345   0.920
#> 5   I5 0.4854016 0.3841333 0.5794530   0.720
#> 6   I6 0.6119258 0.4710655 0.7186107   0.332
#> 7   I7 0.5700365 0.4666846 0.6679455   0.298
#> 8   I8 0.5889510 0.5261345 0.6559714   0.024
#> 9   I9 0.4629239 0.3609226 0.5714935   0.574
#> 10 I10 0.5000000 0.3990186 0.5999256   0.898
#> 11 I11 0.5973439 0.4530193 0.7227229   0.306
#> 12 I12 0.4748612 0.3672819 0.5934269   0.668
#> 13 I13 0.5687019 0.4959404 0.6350083   0.124
#> 14 I14 0.3425826 0.2292110 0.4590419   0.036
#> 15 I15 0.4848626 0.3581631 0.6082242   0.766
#> 16 I16 0.6243822 0.5436709 0.7044103   0.012
```

The parameter `delete = TRUE` removes non-significant incidents. For
example:

``` r
result <- bootMargin( CE = CC, thr.cause = 0.5, thr.effect = 0.5, reps = 1000, delete = TRUE)
```

The I14 variable was removed due to not being significant.

``` r
result$byCause
#>    Var      Mean       LCI       UCI p.value
#> 1   I1 0.5348258 0.4836417 0.5929139   0.208
#> 2   I2 0.6041581 0.5516556 0.6560250   0.000
#> 3   I3 0.4397077 0.3859486 0.4905806   0.014
#> 4   I4 0.5000030 0.4381093 0.5565935   0.974
#> 5   I5 0.5474336 0.4891454 0.6040417   0.136
#> 6   I6 0.5568240 0.4917324 0.6215583   0.108
#> 7   I7 0.5389350 0.4912935 0.5914500   0.168
#> 8   I8 0.5489056 0.4775148 0.6202926   0.254
#> 9   I9 0.4697811 0.4157287 0.5244833   0.252
#> 10 I10 0.4920433 0.4214782 0.5569296   0.810
#> 11 I11 0.6097542 0.5674417 0.6542611   0.000
#> 12 I12 0.4700890 0.4197444 0.5180454   0.198
#> 13 I13 0.5557363 0.4763333 0.6399583   0.194
#> 15 I15 0.5022127 0.4571814 0.5496354   0.916
#> 16 I16 0.5357146 0.4857083 0.5876678   0.180
```

``` r
result$byEffect
#>    Var      Mean       LCI       UCI p.value
#> 1   I1 0.5047513 0.3916036 0.6109237   0.960
#> 2   I2 0.5656963 0.4613186 0.6673417   0.390
#> 3   I3 0.4472846 0.3481754 0.5498090   0.336
#> 4   I4 0.4948566 0.3697909 0.6177810   0.828
#> 5   I5 0.4854418 0.3874294 0.5744887   0.728
#> 6   I6 0.6108640 0.4849792 0.7198132   0.350
#> 7   I7 0.5695489 0.4659705 0.6723391   0.260
#> 8   I8 0.5867202 0.5196884 0.6525744   0.018
#> 9   I9 0.4626974 0.3579464 0.5673637   0.576
#> 10 I10 0.5008330 0.4007876 0.6110000   0.944
#> 11 I11 0.5948503 0.4578358 0.7235189   0.240
#> 12 I12 0.4726680 0.3597669 0.5845672   0.722
#> 13 I13 0.5689810 0.4921891 0.6423071   0.156
#> 15 I15 0.4844942 0.3571560 0.6062154   0.810
#> 16 I16 0.6237961 0.5452120 0.7032617   0.018
```

The `plot = TRUE` parameter allows for the generation of the
Dependence-Influence plot.

``` r
result <- bootMargin( CE = CC, thr.cause = 0.5, thr.effect = 0.5, reps = 1000, delete = TRUE, plot = TRUE)
result$plot
```

<img src="man/figures/README-unnamed-chunk-17-1.png" width="100%" />

#### Example: Chained bipartite graphs

The `CC`, `CE`, and `EE` parameters are used for chained bipartite
graphs. The other parameters maintain their functionality except for the
delete parameter, which now returns the three entered three-dimensional
incidence arrays but assigns zero to the non-significant edges.

``` r
result <- bootMargin( CC = CC, CE = CE, EE = EE, thr.cause = 0.5, thr.effect = 0.5, reps = 1000, delete = TRUE)
names(result)
#> [1] "CC"       "CE"       "EE"       "byCause"  "byEffect"
```

### centralitry()

The `centrality()` function calculates the median betweenness
centrality, confidence intervals, and the selected method for
calculating the centrality distribution for complete and chained
bipartite graphs using multiple key informants.

The function returns an object of type data.frame that contains the
following components:

-   Var: Name of the variable.
-   Median: Median calculated.
-   LCI: Lower Confidence Interval.
-   UCI: Upper Confidence Interval.
-   Method: Statistical method used associated with the model parameter.

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
-   **parallel:** Establece el tipo de operación en paralelo requerida.
    Las opciones son “multinúcleo”, “snow” y “no”. Por defecto
    `paralelo = "no"`.
-   **ncpus:** Define el número de núcleos a utilizar. Por defecto
    `ncpus = 1`.

#### Example: Complete graphs

``` r
result <- centrality(CE = CC, model = "median", reps = 300)
#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints

#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints

#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints

#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints
result
#>    Var    Median       LCI      UCI Method pValue
#> 1   I1 20.000000 7.2916667 41.50000 median     NA
#> 2   I2 14.500000 2.5000000 24.77778 median     NA
#> 3   I3  6.851190 0.3250000 12.58333 median     NA
#> 4   I4  2.079167 0.8333333 21.58333 median     NA
#> 5   I5  7.833333 0.6666667  9.00000 median     NA
#> 6   I6 28.391667 1.0029755 30.11723 median     NA
#> 7   I7 11.500000 2.0000000 41.33333 median     NA
#> 8   I8  7.416667 2.1666667 19.68810 median     NA
#> 9   I9  5.200000 3.1500000 13.50000 median     NA
#> 10 I10  4.250000 1.2500000 12.00000 median     NA
#> 11 I11 22.000000 0.7500000 23.66667 median     NA
#> 12 I12 12.516667 0.5000000 15.36667 median     NA
#> 13 I13  6.208333 2.0000000 12.37500 median     NA
#> 14 I14  0.000000 0.0000000  0.00000      0     NA
#> 15 I15  6.958333 2.0000000 51.60417 median     NA
#> 16 I16 16.166667 9.7051587 59.25000 median     NA
```

#### Example: Chained bipartite graphs

``` r
result <- centrality(CC = CC, CE = CE, EE = EE, model = "median", reps = 300)
#> Warning in norm.inter(t, adj.alpha): extreme order statistics used as endpoints
result
#>    Var    Median        LCI       UCI Method pValue
#> 1   I1 22.000000  7.1666667 46.000000 median     NA
#> 2   I2 13.112500  2.1666667 25.611111 median     NA
#> 3   I3  8.142857  1.1000000 14.100000 median     NA
#> 4   I4  1.791667  0.8333333 25.950000 median     NA
#> 5   I5  7.833333  0.7069133 11.666667 median     NA
#> 6   I6 29.177381  8.3380952 55.083333 median     NA
#> 7   I7 14.450000  3.9166667 46.166667 median     NA
#> 8   I8  8.786905  2.1666667 15.366667 median     NA
#> 9   I9  3.825000  0.2678571  8.750000 median     NA
#> 10 I10  1.642857  0.5145485 12.250000 median     NA
#> 11 I11 18.991667  4.3333333 39.750000 median     NA
#> 12 I12  5.916667  0.5000000 15.866667 median     NA
#> 13 I13  5.866667  1.7202381 14.916667 median     NA
#> 14 I14  0.000000  0.0000000  0.000000      0     NA
#> 15 I15  5.500000  0.2790226 25.045238 median     NA
#> 16 I16 21.166667 14.8103175 67.333333 median     NA
#> 17  B1  3.500000  1.4166667  4.500000 median     NA
#> 18  B2  3.833333  3.0000000  8.777672 median     NA
#> 19  B3  2.238095  1.2500000  3.791667 median     NA
#> 20  B4  5.666667  1.0000000  7.083333 median     NA
```

### FE()

The `FE()` function calculates the forgotten effects, the frequency of
their occurrence, the mean incidence, the confidence intervals, and the
standard error for complete and chained bipartite graphs using multiple
key informants. This function implements bootstrap BCa.

The function returns two list-type objects. The first is `$boot`, which
contains the following information:

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

And the second is `$byExpert`, which contains the following information:

-   From: Indicates the origin of the forgotten effects relationships.
-   Through_x: Dynamic field that represents the intermediate
    relationships of the forgotten effects. For example, for order n
    there will be “though_1” up to “though\_ \<n-1\>”.
-   To: Indicates the end of the forgotten effects relationships.
-   Count: Number of times the forgotten effect was repeated.
-   Expert_x: Dynamic field that represents each of the entered experts.

### 

Parameters

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

#### Example: Complete graphs

``` r
result <- FE(CE = CC, thr = 0.5, maxOrder = 3, reps = 1000)
```

#### Example: Chained bipartite graphs

``` r
result <- FE(CC = CC, CE = CE, EE = EE, thr = 0.5, maxOrder = 4, reps = 1000)
#> Warning in wrapper.FE(CC = CC, CE = CE, EE = EE, thr = thr, maxOrder =
#> maxOrder, : Expert number 7 has no 2nd maxOrder or higher effects.
```

### 

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
