#library("Rcpp")
#library("RcppArmadillo")

#'Fitting Linear Model
#'
#'"lmcpp" is used to fit simple linear model.
#'
#' @param formula a symbolic description of the model to be fitted with specific pattern (i.e. y ~ x1 + x2 where y is the responding variable; x1 and x2 are the covariates for the model)
#' @param data an optional data frame, list or environment containing the variables in the model. If not found in data, the variables are taken from formula.
#' @param prt logical; if TRUE, a formated output will be printed on the screen.
#'
#' @return A list containing the following elements
#'         \itemize{
#'            \item call - return the fitted linear model fomula and the corresponding data.
#'            \item coefficients - a table with the estimated values for each covariates and the intercept as well as their corresponding standard error, t-statistics and (two-sided) p-value.
#'            \item residuals - summary of the usual residuals with min, 1st quantile, median, 3rd quantile, max being computed.
#'            \item fitted.values - the fitted mean values.
#'            \item design.matrix - the design matrix for model fitting
#'            \item Residual standard erro - the square root of the estimated variance of the random error and a corresponding degrees of freedom will also be computed.
#'            \item r.squared - R^2, the 'fraction of variance explained by the model', SSR (variation in fitted values about the overall mean) / SSY (total variation in Y about its overall mean).
#'            \item adj.r.squared - adjusted version of R^2, penalized based on number of covariates.
#'            \item cov.unscaled - a table of (unscaled) covariances of the coeficients.
#'            \item sd.beta - the corresponding standard error for the estimated coefficient.
#'            \item t value - the t-statistic for corresponding variable.
#'            \item Pr(>|t|) - the corresponding (two-sided) p-value for the t-statistic
#'            \item fstatistic - the test statistic for F-tests. Variation Between Sample Means / Variation Within the Samples.
#'         }
#'
#' @export

lmcpp = function(formula, data, prt = FALSE) {

  cl = match.call()
  if ( hasArg(data) ) input.data = model.frame(formula, data)
    else input.data = model.frame(formula)

  y = input.data[,1]
  if ( !is.numeric(y) ) stop( "input values should be numeric" )
  x = as.matrix( input.data[,-1] )
  obs.name = rownames(input.data)
  var.name = colnames(input.data)[-1]
  if ( is.null(var.name) ) var.name = c("(Intercept)", paste0( "x", 1:ncol(x)) )
  var.name = c("(Intercept)", var.name)
  if ( is.null(obs.name) ) obs.name = as.character( 1:nrow(x) )
  fit = lmCpp(x,y)
  fit$call = cl
  fit$coefficients = drop( fit$coefficients )
  names( fit$coefficients ) = var.name
  names( fit$sd.beta ) = var.name
  names( fit$`t value` ) = var.name
  names( fit$`Pr(>|t|)` ) = var.name
  names( fit$fitted.values ) = obs.name
  names( fit$residuals ) = obs.name
  fit$cov.unscaled = fit$cov.unscale
  fit[["cov.unscale"]] = NULL
  dimnames( fit$cov.unscaled ) = list(var.name, var.name)

  if( prt ) {
    cat("\nCall:\n")
    print( fit$call )
    cat("\nCoeffiecients:\n")
    print( round(fit$coefficients, 5) )
    cat("\n")
  }
  return( fit )

}

#'Summarizing Linear Model Fits
#'
#'Summarize the output of "lmCpp" function
#'
#' @param object the fitting results of "lmCpp".
#' @param correlation logical; if TRUE, the correlation matrix of the estimated parameters is returned and printed.
#' @param prt logical; if TRUE, a summarized table will be computed to the screen
#' @return A list containing the following elements
#'         \itemize{
#'            \item call - the fitted linear model fomula.
#'            \item Residuals - summary of the usual residuals with min, 1st quantile, median, 3rd quantile, max being computed.
#'            \item Coefficients - a table with the estimated values for each covariates and the intercept as well as their corresponding standard error, t-statistics and (two-sided) p-value.
#'            \item Residual standard erro - the square root of the estimated variance of the random error and a corresponding degrees of freedom will also be computed.
#'            \item r.squared - R^2, the 'fraction of variance explained by the model', SSR (variation in fitted values about the overall mean) / SSY (total variation in Y about its overall mean).
#'            \item adj.r.squared - adjusted version of R^2, penalized based on number of covariates.
#'            \item cov.unscaled - a table of (unscaled) covariances of the coeficients.
#'            \item correlation - the correlation table corresponding to the above cov.unscaled table, if correlation = TRUE is specified.
#'         }
#'
#' @export

summary.lmcpp = function(object, correlation = FALSE, prt = TRUE) {

  fit = object
  summ = fit
  var.name = names( fit$coefficients )
  summ$aliased = drop( is.na( coef(fit) ) )
  summ$coefficients = cbind( fit$coefficients, fit$sd.beta, fit$`t value`, fit$`Pr(>|t|)` )
  dimnames(summ$coefficients) = list( var.name, c("Estimate", "Std. Error", "t value", "Pr(>|t|)") )

  fdf = length(fit$coefficients) - 1
  summ$fstatistic = c(fit$fstatistic, fdf, fit$df.residual)
  names(summ$fstatistic) = c("value", "numdf", "dendf")
  summ$fpval = pf(fit$fstatistic, fdf, fit$df.residual, lower.tail = F)

  if ( prt ) {
    cat("\nCall:\n")
    print( summ$call )
    cat("\nResiduals:\n")
    print( round(summary(fit$residuals)[-4], 5) )
    cat("\nCoefficients:\n")
    print( round(summ$coefficients, 5) )
    cat( sprintf("\nResidual standard erro:%.2f on %d degrees of freedom\n", fit$sigma, fit$df.residual) )
    cat( sprintf("Multiple R-squared:\t%.4f,\tAdjusted R-squared:\t%.4f\n", fit$r.squared, fit$adj.r.squared) )
    cat( sprintf("F-statistic: %.2f on %d and %d DF, p-value: %e\n", fit$fstatistic, fdf, fit$df.residual, summ$fpval) )
  }

  if ( correlation ) {
    summ$correlation = (fit$cov.unscaled * fit$sigma^2) / outer(fit$sd.beta, fit$sd.beta)
    dimnames( summ$correlation ) = list( var.name, var.name )
    cor.tri = summ$correlation

    if ( prt ) {
      cat("\nCorrelation of Coefficients:\n")
      cor.tri = round(cor.tri, 2)
      cor.tri[upper.tri(cor.tri, diag = TRUE)] = ""
      print( cor.tri[-1, -ncol(cor.tri)], quote = FALSE )
    }

  }
  summ[["sd.beta"]] = NULL
  summ[["t value"]] = NULL
  summ[["Pr(>|t|)"]] = NULL
  return( summ )

}
