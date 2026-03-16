\name{genRaw}
\alias{genRaw}
\title{Generate Raw Genetic Data}
\description{
  Simulates SNP genotype data with a specified minor allele frequency range
  and correlation structure.
}
\usage{
genRaw(L, M, rho, n)
}
\arguments{
  \item{L}{Number of independent LD blocks.}
  \item{M}{Number of SNPs per LD block.}
  \item{rho}{Correlation parameter controlling linkage disequilibrium within blocks.}
  \item{n}{Sample size.}
}
\value{
  An \eqn{n \times (L \times M)}{n x (L*M)} matrix of simulated genotype values (0, 1, or 2).
}
\examples{
  \dontrun{
    X <- genRaw(L = 10, M = 5, rho = 0.3, n = 500)
  }
}
