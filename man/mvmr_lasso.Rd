\name{mvmr_lasso}
\alias{mvmr_lasso}
\alias{cv.mvmr_lasso}
\title{Multivariable LASSO Mendelian Randomization}
\description{
  Implements multivariable MR with LASSO-based invalid instrument selection.
  \code{cv.mvmr_lasso} performs cross-validation to select the LASSO penalty
  parameter; \code{mvmr_lasso} uses this to obtain post-LASSO causal estimates.
}
\usage{
mvmr_lasso(bx, by, seby)
cv.mvmr_lasso(bx, by, seby)
}
\arguments{
  \item{bx}{Matrix of SNP-exposure association estimates (SNPs x exposures).}
  \item{by}{Vector of SNP-outcome association estimates.}
  \item{seby}{Vector of standard errors for SNP-outcome associations.}
}
\value{
  \code{cv.mvmr_lasso} returns a list with elements \code{fit} (LASSO
  coefficients at the selected lambda) and \code{lambda}.

  \code{mvmr_lasso} returns a list with elements \code{thest}, \code{a},
  \code{lambda}, \code{th_post}, and \code{se_post}.
}
\examples{
  \dontrun{
    res <- mvmr_lasso(bx = gamma1, by = Gamma2, seby = se2)
  }
}
