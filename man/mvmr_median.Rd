\name{mvmr_median}
\alias{mvmr_median}
\alias{mvmr_med_boot}
\title{Multivariable Weighted Median Mendelian Randomization}
\description{
  Implements multivariable weighted median MR using quantile regression.
  \code{mvmr_med_boot} computes bootstrap standard errors.
}
\usage{
mvmr_median(bx, sebx, by, seby, boot = FALSE, boot_it = 1000)
mvmr_med_boot(bx, sebx, by, seby, N)
}
\arguments{
  \item{bx}{Matrix of SNP-exposure association estimates (SNPs x exposures).}
  \item{sebx}{Matrix of standard errors for SNP-exposure associations.}
  \item{by}{Vector of SNP-outcome association estimates.}
  \item{seby}{Vector of standard errors for SNP-outcome associations.}
  \item{boot}{Logical; if \code{TRUE}, bootstrap standard errors are computed.}
  \item{boot_it}{Number of bootstrap iterations (default 1000).}
  \item{N}{Number of bootstrap iterations in \code{mvmr_med_boot}.}
}
\value{
  \code{mvmr_median} returns a list with element \code{coefficients} and,
  if \code{boot = TRUE}, element \code{se}.

  \code{mvmr_med_boot} returns a vector of bootstrap standard errors.
}
\examples{
  \dontrun{
    res <- mvmr_median(bx = gamma1, sebx = se1, by = Gamma2, seby = se2)
  }
}
