// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

// matmulti
NumericMatrix matmulti(NumericMatrix m1, NumericMatrix m2);
RcppExport SEXP _lmcpp_matmulti(SEXP m1SEXP, SEXP m2SEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type m1(m1SEXP);
    Rcpp::traits::input_parameter< NumericMatrix >::type m2(m2SEXP);
    rcpp_result_gen = Rcpp::wrap(matmulti(m1, m2));
    return rcpp_result_gen;
END_RCPP
}
// matvecmulti
NumericMatrix matvecmulti(NumericMatrix m, NumericVector v);
RcppExport SEXP _lmcpp_matvecmulti(SEXP mSEXP, SEXP vSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type m(mSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type v(vSEXP);
    rcpp_result_gen = Rcpp::wrap(matvecmulti(m, v));
    return rcpp_result_gen;
END_RCPP
}
// arma2mat
NumericMatrix arma2mat(arma::mat x);
RcppExport SEXP _lmcpp_arma2mat(SEXP xSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< arma::mat >::type x(xSEXP);
    rcpp_result_gen = Rcpp::wrap(arma2mat(x));
    return rcpp_result_gen;
END_RCPP
}
// arma2vec
NumericVector arma2vec(arma::vec x);
RcppExport SEXP _lmcpp_arma2vec(SEXP xSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< arma::vec >::type x(xSEXP);
    rcpp_result_gen = Rcpp::wrap(arma2vec(x));
    return rcpp_result_gen;
END_RCPP
}
// lmCpp
List lmCpp(NumericMatrix x, NumericVector y);
RcppExport SEXP _lmcpp_lmCpp(SEXP xSEXP, SEXP ySEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericMatrix >::type x(xSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type y(ySEXP);
    rcpp_result_gen = Rcpp::wrap(lmCpp(x, y));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_lmcpp_matmulti", (DL_FUNC) &_lmcpp_matmulti, 2},
    {"_lmcpp_matvecmulti", (DL_FUNC) &_lmcpp_matvecmulti, 2},
    {"_lmcpp_arma2mat", (DL_FUNC) &_lmcpp_arma2mat, 1},
    {"_lmcpp_arma2vec", (DL_FUNC) &_lmcpp_arma2vec, 1},
    {"_lmcpp_lmCpp", (DL_FUNC) &_lmcpp_lmCpp, 2},
    {NULL, NULL, 0}
};

RcppExport void R_init_lmcpp(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
