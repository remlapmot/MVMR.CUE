

genRaw <- function(L, M, rho, n){
  maf = runif(M*L, 0.05, 0.5);
  SIGMA = matrix(nrow=M,ncol=M)
  for (i in 1:M){
    for (j in 1:M){
      SIGMA[i,j] = rho^(abs(i-j));
    }
  }
  
  nsnp = L*M;
  X = NULL;
  for ( l in 1:L ){
    
    index = (M*(l-1)+1): (M*l);
    AAprob = maf[index]^2.;
    Aaprob = 2*maf[index]*(1-maf[index]);
    quanti = matrix(c(1-Aaprob-AAprob, 1- AAprob),M,2);
    Xt = rmvnorm(n, mean=rep(0,M), sigma=SIGMA, method="chol")
    Xt2 = matrix(0,n,M);
    for (j in 1:M){
      cutoff = qnorm(quanti[j,]);
      Xt2[Xt[,j] < cutoff[1],j] = 0;
      Xt2[Xt[,j] >= cutoff[1] & Xt[,j] < cutoff[2],j] = 1;  ## attention
      Xt2[Xt[,j] >= cutoff[2],j] = 2;
    }
    X <- cbind(X,Xt2);
  }
  return(X)
}


mvmr_med_boot = function(bx, sebx, by, seby, N){
  est = sapply(1:N, function(i){
    p = length(by)
    k = dim(bx)[2]
    Sx = lapply(1:p, function(j){diag(sebx[j, ]^2)})
    bxboot = sapply(1:p, function(j){mvrnorm(1, bx[j, ], Sx[[j]])})
    bxboot = t(bxboot)
    byboot = rnorm(p, by, seby)
    rq(byboot ~ bxboot - 1, weights = seby^-2)$coefficients
  })
  apply(est, 1, sd)
}

mvmr_median = function(bx, sebx, by, seby, boot = FALSE, boot_it = 1000){
  qr_mod = rq(by ~ bx - 1, weights = seby^-2)
  if (boot == TRUE){
    boot_se = mvmr_med_boot(bx, sebx, by, seby, boot_it)
    return(list("coefficients" = qr_mod$coefficients, "se" = boot_se))
  } else {
    return(list("coefficients" = qr_mod$coefficients))
  }
}

cv.mvmr_lasso = function(bx, by, seby){
  p = dim(bx)[1]
  k = dim(bx)[2]
  S = diag(seby^-2)
  b = S^(1/2) %*% bx
  Pb = b %*% solve(t(b) %*% b, t(b))
  xlas = (diag(p) - Pb) %*% S^(1/2)
  ylas = (diag(p) - Pb) %*% S^(1/2) %*% by
  alas = glmnet(xlas, ylas, intercept = FALSE)
  lamseq = sort(alas$lambda)
  lamlen = length(lamseq)
  rse = sapply(1:lamlen, function(j){
    av = which(alas$beta[, (lamlen - j + 1)] == 0)
    mod = lm.fit(as.matrix(S[av, av]^(1/2) %*% bx[av, ]), S[av, av]^(1/2) %*% by[av])
    c(sqrt(t(mod$residuals) %*% (mod$residuals) / (mod$df.residual)), length(av))
  })
  rse_inc = rse[1, 2:lamlen] - rse[1, 1:(lamlen-1)]
  het = which(rse[1, 2:lamlen] > 1 & rse_inc > ((qchisq(0.95, 1) / rse[2, 2:lamlen])))
  if (length(het) == 0){
    lam_pos = 1
  } else {
    lam_pos = min(het)
  }
  num_valid = rev(sapply(1:lamlen, function(j){sum(alas$beta[, j]==0)}))
  min_lam_pos = min(which(num_valid > k))
  if (lam_pos < min_lam_pos){lam_pos = min_lam_pos}
  return(list(fit = alas$beta[, (lamlen - lam_pos + 1)], lambda = lamseq[lam_pos]))
}

mvmr_lasso = function(bx, by, seby){
  p = dim(as.matrix(bx))[1]
  k = dim(as.matrix(bx))[2]
  S = diag(seby^-2)
  sn = sign(bx[, 1])
  bx_or = bx * sn
  by_or = by * sn
  cv.alas = cv.mvmr_lasso(bx_or, by_or, seby)
  a1 = cv.alas$fit
  e = by_or - a1
  thest = solve(t(bx_or) %*% S %*% bx_or, t(bx_or) %*% S %*% e)
  v = which(a1==0)
  mvmr_mod = mr_mvivw(mr_mvinput(bx = bx_or[v, ], bxse = bx_or[v, ],
                                 by = by_or[v], byse = seby[v]))
  th_post = mvmr_mod$Estimate
  se_post = mvmr_mod$StdError
  return(list(thest = thest, a = a1, lambda = cv.alas$lambda,
              th_post = th_post, se_post = se_post))
}

mvmr_robust = function(bx, by, seby, k.max = 500, maxit.scale = 500){
  robmod = lmrob(by ~ bx - 1, weights = seby^-2, k.max = k.max,
                 maxit.scale = maxit.scale)
  coefficients = summary(robmod)$coef[, 1]
  se = summary(robmod)$coef[, 2] / min(summary(robmod)$sigma, 1)
  return(list("coefficients" = coefficients, "se" = se))
}

mr_horse_model = function() {
  for (i in 1:N){
    by[i] ~ dnorm(mu[i], 1/(sy[i] * sy[i]))
    mu[i] = theta * bx0[i] + alpha[i]
    bx[i] ~ dnorm(bx0[i], 1 / (sx[i] * sx[i]))
    
    bx0[i] ~ dnorm(mx0 + (sqrt(vx0)/(tau * phi[i])) * rho[i] * alpha[i], 1 / ((1 - rho[i]^2) * vx0))
    r[i] ~ dbeta(10, 10);T(, 1)
    rho[i] = 2*r[i] -1
    
    alpha[i] ~ dnorm(0, 1 / (tau * tau * phi[i] * phi[i]))
    phi[i] = a[i] / sqrt(b[i])
    a[i] ~ dnorm(0, 1);T(0, )
    b[i] ~ dgamma(0.5, 0.5)
  }
  
  c ~ dnorm(0, 1);T(0, )
  d ~ dgamma(0.5, 0.5)
  tau = c / sqrt(d)
  
  vx0 ~ dnorm(0, 1);T(0, )
  mx0 ~ dnorm(0, 1)
  
  theta ~ dunif(-10, 10)
}

mvmr_horse_model = function() {
  for (i in 1:N){
    by[i] ~ dnorm(mu[i], 1 / (sy[i] * sy[i]))
    mu[i] = inprod(bx0[i, 1:K], theta) + alpha[i]
    bx[i,1:K] ~ dmnorm(bx0[i,1:K], Tx[1:K, ((i-1)*K+1):(i*K)])
    
    kappa[i] = (rho[i]^2 / (1 + K*rho[i]^2))
    bx0[i,1:K] ~ dmnorm(mx + sx0 * rho[i] * alpha[i] / (phi[i] * tau), A - kappa[i] * B)
    r[i] ~ dbeta(10, 10);T(, 1)
    rho[i] = 2*r[i] -1
    alpha[i] ~ dnorm(0, 1 / (tau * tau * phi[i] * phi[i]))
    phi[i] = a[i] / sqrt(b[i])
    a[i] ~ dnorm(0, 1);T(0, )
    b[i] ~ dgamma(0.5, 0.5)
  }
  
  c ~ dnorm(0, 1);T(0, )
  d ~ dgamma(0.5, 0.5)
  tau = c / sqrt(d)
  
  mx ~ dmnorm(rep(0, K), R[,])
  
  for (k in 1:K){
    vx0[k] ~ dnorm(0, 1);T(0, )
    sx0[k] = sqrt(vx0[k])
    theta[k] ~ dunif(-10, 10)
    for (j in 1:K){
      A[j, k] = ifelse(j==k, 1/vx0[j], 0)
      B[j, k] = 1 / (sx0[j] * sx0[k])
    }
  }
}

mr_horse = function(D, no_ini = 3, variable.names = "theta", n.iter = 10000, n.burnin = 10000){
  if("theta" %in% variable.names){
    variable.names = variable.names
  } else{
    variable.names = c("theta", variable.names)
  }
  jags_fit = jags(data = list(by = D$betaY, bx = D$betaX, sy = D$betaYse, sx = D$betaXse, N = length(D$betaY)),
                  parameters.to.save = variable.names,
                  n.chains = no_ini,
                  n.iter = n.burnin + n.iter,
                  n.burnin = n.burnin,
                  model.file = mr_horse_model)
  mr.coda = as.mcmc(jags_fit)
  mr_estimate = data.frame("Estimate" = round(unname(summary(mr.coda[, "theta"])$statistics[1]), 3),
                           "SD" = round(unname(summary(mr.coda[, "theta"])$statistics[2]), 3),
                           "2.5% quantile" = round(unname(summary(mr.coda[, "theta"])$quantiles[1]), 3),
                           "97.5% quantile" = round(unname(summary(mr.coda[, "theta"])$quantiles[5]), 3),
                           "Rhat" = round(unname(gelman.diag(mr.coda)$psrf[1]), 3))
  names(mr_estimate) = c("Estimate", "SD", "2.5% quantile", "97.5% quantile", "Rhat")
  return(list("MR_Estimate" = mr_estimate, "MR_Coda" = mr.coda))
}

mvmr_horse = function(D, no_ini = 3, variable.names = "theta", n.iter = 10000, n.burnin = 10000){
  if("theta" %in% variable.names){
    variable.names = variable.names
  } else{
    variable.names = c("theta", variable.names)
  }
  
  p = dim(D)[1]
  K = sum(sapply(1:dim(D)[2], function(j){substr(names(D)[j], 1, 5)=="betaX"}))/2
  
  Bx = D[, sprintf("betaX%i", 1:K)]
  Sx = D[, sprintf("betaX%ise", 1:K)]
  Tx = matrix(nrow = K, ncol = p*K)
  for (j in 1:p){
    Tx[, ((j-1)*K+1):(j*K)] = diag(1 / Sx[j, ]^2)
  }
  jags_fit = jags(data = list(by = D$betaY, bx = Bx, sy = D$betaYse, Tx = Tx, N = p, K = K, R = diag(K)),
                  parameters.to.save = variable.names,
                  n.chains = no_ini,
                  n.iter = n.burnin + n.iter,
                  n.burnin = n.burnin,
                  model.file = mvmr_horse_model)
  mr.coda = as.mcmc(jags_fit)
  mr_estimate = data.frame("Parameter" = sprintf("theta[%i]", 1:K),
                           "Estimate" = round(unname(summary(mr.coda)$statistics[sprintf("theta[%i]", 1:K), 1]), 3),
                           "SD" = round(unname(summary(mr.coda)$statistics[sprintf("theta[%i]", 1:K), 2]), 3),
                           "2.5% quantile" = round(unname(summary(mr.coda)$quantiles[sprintf("theta[%i]", 1:K), 1]), 3),
                           "97.5% quantile" = round(unname(summary(mr.coda)$quantiles[sprintf("theta[%i]", 1:K), 5]), 3),
                           "Rhat" = round(unname(gelman.diag(mr.coda)$psrf[sprintf("theta[%i]", 1:K), 1]), 3))
  names(mr_estimate) = c("Parameter", "Estimate", "SD", "2.5% quantile", "97.5% quantile", "Rhat")
  return(list("MR_Estimate" = mr_estimate, "MR_Coda" = mr.coda))
}
