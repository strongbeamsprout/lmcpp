#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

// [[Rcpp::export]]
NumericMatrix matmulti ( NumericMatrix m1, NumericMatrix m2 ) {
  if ( m1.ncol() != m2.nrow() ) stop("incompatible dimensions");
  NumericMatrix prod( m1.nrow(), m2.ncol() );
  for ( int i = 0; i < m1.nrow(); ++i) {
    for ( int j = 0; j < m2.ncol(); ++j) {
      prod(i,j) = sum ( m1(i,_) * m2(_,j) );
    }
  }
  return (prod);
}

// [[Rcpp::export]]
NumericMatrix matvecmulti ( NumericMatrix m, NumericVector v ) {
  if ( m.ncol() != v.length() ) stop("incompatible dimensions");
  NumericMatrix prod (m.nrow(), 1 );
  for ( int i = 0; i < m.nrow(); ++i) {
    prod(i,0) = sum ( m(i,_) * v );
  }
  return (prod);
}

// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
NumericMatrix arma2mat (arma::mat x) {
  return( NumericMatrix(x.n_rows,x.n_cols,x.memptr()) );

}

// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
NumericVector arma2vec (arma::vec x) {
  return (NumericVector(x.begin(), x.end()));
}

// [[Rcpp::depends(RcppArmadillo)]]
// [[Rcpp::export]]
List lmCpp(NumericMatrix x, NumericVector y) {
  int nrows = x.nrow();
  int ncols = x.ncol();
//  CharacterVector coefname = colnames(x);
//  coefname.push_front("(Intercept)");
  if ( ncols == 0 ) {
    List out = List::create(Named("coefficients",R_NilValue),Named("residuals",y),
                            Named("fitted.values",0*y),Named("rank",0),Named("df.residual",y.length()));
    return out;
  }
  if ( y.length() != nrows ) stop("incompatible dimensions");
  NumericMatrix NewX (nrows, ncols+1);
  NewX( _, 0) = rep(1,nrows);
  ncols = NewX.ncol();
  for ( int j=1; j < ncols; ++j) {
    NewX(_,j) = x(_,j-1);
  }
//  colnames(NewX) = coefname;


  NumericMatrix ssx = matmulti( transpose( NewX ), NewX ) ;
  NumericMatrix ssxy = matvecmulti ( transpose( NewX ), y );
  double ssy = sum( pow(y - rep(mean(y),y.length()),2) );
  arma::mat x_ = as<arma::mat>(ssx);
  arma::mat acov_unscale = inv(x_);
  NumericMatrix cov_unscaled = arma2mat (acov_unscale);
  NumericVector coefficients = matmulti (cov_unscaled, ssxy);
//  rownames(coefficients) = coefname;

  NumericMatrix fv = matvecmulti( NewX, coefficients );
  NumericVector fitted_values = fv(_,0);
  NumericVector residuals = y - fitted_values;
  int df_residuals = nrows - ncols;
  double mse = ( sum(pow(residuals,2)) / df_residuals );
  double sigma = sqrt(mse);
  NumericVector sd_beta = sqrt(mse * diag(cov_unscaled));
  NumericVector tstats = coefficients / sd_beta;
  NumericVector tpval = pt( -abs(tstats), df_residuals )*2;
  double ssr = sum( pow(fitted_values-mean(y),2) );
  double fstats = (ssr / (ncols-1) ) / mse;
//  double fpval = pf( fstats, ncols-1, df_residuals, false);
  double r_squared = ssr / ssy;
  double adj_r_squared = 1 - mse/(ssy/(nrows-1));

  List out = List::create(Named("fitted.values",fitted_values),Named("residuals",residuals),Named("sd.beta",sd_beta),
                          Named("coefficients",coefficients),Named("cov.unscale",cov_unscaled),Named("sigma",sigma),
                          Named("r.squared",r_squared),Named("adj.r.squared",adj_r_squared),Named("t value",tstats),
                          Named("Pr(>|t|)",tpval),Named("fstatistic",fstats),Named("df.residual",df_residuals));
  return out;

}


