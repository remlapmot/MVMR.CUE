\name{gamma1}
\alias{gamma1}
\alias{Gamma2}
\alias{se1}
\alias{se2}
\docType{data}
\title{Example MVMR Summary Statistics}
\description{
  Example summary statistics for multivariable Mendelian randomization,
  containing association estimates and standard errors for 200 genetic
  variants with two exposures and one outcome.
}
\usage{
data(gamma1)
data(Gamma2)
data(se1)
data(se2)
}
\format{
  \describe{
    \item{\code{gamma1}}{A 200 x 2 matrix of SNP-exposure association estimates.}
    \item{\code{Gamma2}}{A matrix of 200 SNP-outcome association estimates.}
    \item{\code{se1}}{A 200 x 2 matrix of standard errors for SNP-exposure associations.}
    \item{\code{se2}}{A matrix of 200 standard errors for SNP-outcome associations.}
  }
}
\keyword{datasets}
