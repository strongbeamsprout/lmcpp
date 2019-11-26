# lmcpp
a rewrite simplified version of "lm/summary.lm" function in R

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install beforehand so that this package can run smoothly

```
install.packages("Rcpp")
install.packages("RcppArmadillo")
```

### Installing

```
# The way to install lmcpp is to install from GitHub:
# install.packages("devtools")
devtools::install_github("strongbeamsprout/lmcpp.git")
```

## Usage

```
#load the package
library(lmcpp)

#load test data
data(mtcars)

#run a linear regression and 
fit = lmcpp(mpg ~ cyl + hp, data = mtcars, prt = TRUE)
#>Call:
#>lmcpp(formula = mpg ~ cyl + hp, data = mtcars, prt = TRUE)
#>
#>Coeffiecients:
#>(Intercept)         cyl          hp 
#> 36.9083305  -2.2646936  -0.0191217 

#summarize the regression output
summ = summary.lmcpp(fit, correlation = TRUE, prt = TRUE)
#>Residuals:
#>    Min.  1st Qu.   Median  3rd Qu.     Max. 
#>-0.68735 -0.12369  0.00758  0.14118  0.82490 
#>
#>Coefficients:
#>     Estimate Std. Error  t value Pr(>|t|)
#>[1,] 36.90833    2.19080 16.84698  0.00000
#>[2,] -2.26469    0.57589 -3.93252  0.00048
#>[3,] -0.01912    0.01500 -1.27472  0.21253
#>
#>Residual standard erro:3.17 on 29 degrees of freedom
#>Multiple R-squared:	0.7407,	Adjusted R-squared:	0.7228
#>F-statistic: 41.42 on 2 and 29 DF, p-value: 3.161781e-09
#>
#>Correlation of Coefficients:
#>     [,1]  [,2] 
#>[1,] -0.01      
#>[2,] 0     -0.01
```

## Versioning

This is the 1st version and might be the last version of lmcpp package.

## Authors

* **strongbeamsprout** - [strongbeamsprout](https://github.com/strongbeamsprout)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* The original code of the "lm/summary.lm" function in R
* Biostatistics 625 class
