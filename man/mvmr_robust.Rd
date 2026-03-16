\name{mvmr_robust}
\alias{mvmr_robust}
\title{Multivariable Robust Regression Mendelian Randomization}
\description{
  Implements multivariable MR using robust regression (MM-estimator) with
  inverse-variance weighting.
}
\usage{
mvmr_robust(bx, by, seby, k.max = 500, maxit.scale = 500)
}
\arguments{
  \item{bx}{Matrix of SNP-exposure association estimates (SNPs x exposures).}
  \item{by}{Vector of SNP-outcome association estimates.}
  \item{seby}{Vector of standard errors for SNP-outcome associations.}
  \item{k.max}{Maximum number of iterations for the M-step (default 500).}
  \item{maxit.scale}{Maximum number of iterations for the scale estimation (default 500).}
}
\value{
  A list with elements \code{coefficients} and \code{se}.
}
\examples{
  \dontrun{
    res <- mvmr_robust(bx = gamma1, by = Gamma2, seby = se2)
  }
}
