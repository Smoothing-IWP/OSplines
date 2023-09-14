
<!-- README.md is generated from README.Rmd. Please edit that file -->

# OSplines

<!-- badges: start -->
<!-- badges: end -->

The goal of the `OSplines` package is to efficiently implement
model-based smoothing with the integrated Wiener’s process, within a
variety of Bayesian hierarchical models.

## Installation

You can install the development version of OSplines from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("https://github.com/Smoothing-IWP/OSplines/tree/development")
```

## Example

This is a basic example which shows you how to use `OSplines` to fit and
analyze some models, we consider the following data set of COVID-19
mortality in Canada, which is available in the package:

``` r
library(OSplines)
#> Loading required package: tidyverse
#> ── Attaching packages ─────────────────────────────────────── tidyverse 1.3.2 ──
#> ✔ ggplot2 3.4.1      ✔ purrr   0.3.4 
#> ✔ tibble  3.1.8      ✔ dplyr   1.0.10
#> ✔ tidyr   1.2.1      ✔ stringr 1.4.1 
#> ✔ readr   2.1.2      ✔ forcats 0.5.2 
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> Loading required package: Matrix
#> 
#> 
#> Attaching package: 'Matrix'
#> 
#> 
#> The following objects are masked from 'package:tidyr':
#> 
#>     expand, pack, unpack
#> 
#> 
#> Loading required package: aghq
## basic example code
head(covid_canada)
#>         Date new_deaths        t weekdays1 weekdays2 weekdays3 weekdays4
#> 1 2020-03-01          0 591.0323        -1        -1        -1        -1
#> 2 2020-03-02          0 591.0645         1         0         0         0
#> 3 2020-03-03          0 591.0968         0         1         0         0
#> 4 2020-03-04          0 591.1290         0         0         1         0
#> 5 2020-03-05          0 591.1613         0         0         0         1
#> 6 2020-03-06          0 591.1935         0         0         0         0
#>   weekdays5 weekdays6 index
#> 1        -1        -1     1
#> 2         0         0     2
#> 3         0         0     3
#> 4         0         0     4
#> 5         0         0     5
#> 6         1         0     6
```

We can fit a model with $\text{IWP}_3(\sigma)$ prior using the function
`model_fit`:

``` r
fit_result <- model_fit(new_deaths ~ weekdays1 + weekdays2 + weekdays3 + weekdays4 + weekdays5 + weekdays6 +
                          f(smoothing_var = t, model = "IWP", order = 3, k = 30), 
                        data = covid_canada, method = "aghq", family = "Poisson")
```

We can take a look at the posterior summary of this model:

``` r
summary(fit_result)
#> Warning: 'Matrix::..2dge' is deprecated.
#> Use '.dense2g' instead.
#> See help("Deprecated") and help("Matrix-deprecated").
#> There are 38 random effects, but max_print = 30, so not computing their summary information.
#> Set max_print higher than 38 if you would like to summarize the random effects.
#> AGHQ on a 1 dimensional posterior with  4 quadrature points
#> 
#> The posterior mode is: -3.245926 
#> 
#> The log of the normalizing constant/marginal likelihood is: -4322.531 
#> 
#> The covariance matrix used for the quadrature is...
#>            [,1]
#> [1,] 0.07936619
#> 
#> Here are some moments and quantiles for the log precision: 
#>               mean        sd     2.5%    median     97.5%
#> theta(t) -3.271182 0.2785344 -3.87922 -3.268308 -2.760093
#> Warning: 'Matrix::..2dge' is deprecated.
#> Use '.dense2g' instead.
#> See help("Deprecated") and help("Matrix-deprecated").
#> Here are some moments and quantiles for the fixed effects: 
#> 
#>               1st Qu.      Median        Mean     3rd Qu.         sd
#> Intercept -5.83467386 -5.38944536 -5.38103535 -4.93597990 0.66875134
#> weekdays1  0.08553402  0.09336717  0.09365016  0.10154757 0.01190516
#> weekdays2  0.07142286  0.07924949  0.07943187  0.08731386 0.01206658
#> weekdays3  0.11883026  0.12713250  0.12664707  0.13441380 0.01166946
#> weekdays4  0.11760402  0.12542216  0.12560977  0.13357553 0.01182332
#> weekdays5  0.04204704  0.05034855  0.05025144  0.05834749 0.01216216
#> weekdays6 -0.16051122 -0.15166826 -0.15169270 -0.14326187 0.01320432
```

We can also see the inferred function $f$:

``` r
plot(fit_result)
```

<img src="man/figures/README-unnamed-chunk-4-1.png" width="100%" />

We can use the `predict` function to obtain the posterior summary of $f$
or its derivative at `new_data`.

For the function $f$:

``` r
predict_f <- predict(fit_result, variable = "t", newdata = data.frame(t = seq(from = 605, to = 617, by = 0.1)))
predict_f %>% ggplot(aes(x = x)) + geom_line(aes(y = mean), lty = "solid") +
  geom_line(aes(y = plower), lty = "dashed") +
  geom_line(aes(y = pupper), lty = "dashed") +
  theme_classic()
```

<img src="man/figures/README-unnamed-chunk-5-1.png" width="100%" />

For the first derivative:

``` r
predict_f1st <- predict(fit_result, variable = "t", newdata = data.frame(t = seq(from = 605, to = 617, by = 0.1)), degree = 1)
predict_f1st %>% ggplot(aes(x = x)) + geom_line(aes(y = mean), lty = "solid") +
  geom_line(aes(y = plower), lty = "dashed") +
  geom_line(aes(y = pupper), lty = "dashed") +
  theme_classic()
```

<img src="man/figures/README-unnamed-chunk-6-1.png" width="100%" />

For the second derivative:

``` r
predict_f2nd <- predict(fit_result, variable = "t", newdata = data.frame(t = seq(from = 605, to = 617, by = 0.1)), degree = 2)
predict_f2nd %>% ggplot(aes(x = x)) + geom_line(aes(y = mean), lty = "solid") +
  geom_line(aes(y = plower), lty = "dashed") +
  geom_line(aes(y = pupper), lty = "dashed") +
  theme_classic()
```

<img src="man/figures/README-unnamed-chunk-7-1.png" width="100%" />
