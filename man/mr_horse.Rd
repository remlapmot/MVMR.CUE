\name{mr_horse}
\alias{mr_horse}
\alias{mvmr_horse}
\title{HORSE Mendelian Randomization via MCMC}
\description{
  Implements the HORSE (Heteroscedastic Outlier-Robust causal effect estimation
  with Shrinkage for plEiotropy) model for univariate (\code{mr_horse}) and
  multivariable (\code{mvmr_horse}) Mendelian randomization using JAGS.
}
\usage{
mr_horse(D, no_ini = 3, variable.names = "theta", n.iter = 10000,
         n.burnin = 10000)
mvmr_horse(D, no_ini = 3, variable.names = "theta", n.iter = 10000,
           n.burnin = 10000)
}
\arguments{
  \item{D}{A data frame containing columns \code{betaY}, \code{betaX},
    \code{betaYse}, \code{betaXse} (and \code{betaX1}, \code{betaX1se},
    \code{betaX2}, \code{betaX2se}, etc. for \code{mvmr_horse}).}
  \item{no_ini}{Number of MCMC chains (default 3).}
  \item{variable.names}{Character vector of parameters to monitor (default \code{"theta"}).}
  \item{n.iter}{Number of MCMC iterations per chain after burn-in (default 10000).}
  \item{n.burnin}{Number of burn-in iterations (default 10000).}
}
\value{
  A list with elements \code{MR_Estimate} (a data frame of point estimates
  and diagnostics) and \code{MR_Coda} (the MCMC samples as a \code{mcmc.list}).
}
\examples{
  \dontrun{
    D <- data.frame(betaY = Gamma2, betaYse = se2,
                    betaX = gamma1, betaXse = se1)
    res <- mr_horse(D)
  }
}
