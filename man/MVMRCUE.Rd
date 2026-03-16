\name{MVMRCUE}
\alias{MVMRCUE}
\alias{MVMRCUEfun}
\alias{MVMRCUEoverlapfun}
\alias{MVMRCUEIndepSample}
\title{Multivariable Mendelian Randomization Accounting for Correlated Pleiotropy}
\description{
  Core functions implementing the MVMR-CUE algorithm for multivariable
  Mendelian randomization that accounts for complex correlated horizontal
  pleiotropy.
}
\usage{
MVMRCUE(gammahM, Gammah, se1M, se2, Re, opts = NULL)
MVMRCUEfun(gammahM, Gammah, se1M, se2)
MVMRCUEoverlapfun(gammahM, Gammah, se1M, se2, Re, Eta)
MVMRCUEIndepSample(gammahM, Gammah, se1M, se2, opts = NULL)
}
\arguments{
  \item{gammahM}{Matrix of SNP-exposure association estimates.}
  \item{Gammah}{Vector of SNP-outcome association estimates.}
  \item{se1M}{Matrix of standard errors for SNP-exposure associations.}
  \item{se2}{Vector of standard errors for SNP-outcome associations.}
  \item{Re}{Correlation matrix for overlapping samples.}
  \item{Eta}{Eta parameter for overlapping samples.}
  \item{opts}{Optional list of algorithm options.}
}
\value{
  A list containing the estimated causal effects and associated statistics.
}
\examples{
  \dontrun{
    result <- MVMRCUE(gamma1, Gamma2, se1, se2, Re = diag(nrow(gamma1)))
  }
}
