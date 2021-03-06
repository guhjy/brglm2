context("comparison comparison of brglmFit with method = 'AS_median' for Poisson with mbrpr")

## mbrpr is supplied under the permission of M. Zambelli, and is part
## of his unpublished undergraduate thesis submitted in 2016 at the
## Department of Statisitcal Science, University of Padova

source(system.file("mbrpr", "mbrpr.R", package = "brglm2"))

## Dobson (1990) Page 93: Randomized Controlled Trial :
counts <- c(18,17,15,20,10,20,25,13,12)
outcome <- gl(3,1,9)
treatment <- gl(3,3)
dobson <- data.frame(counts, outcome, treatment)

tol <- sqrt(.Machine$double.eps)

test_that("MBR estimates and std. errors from brglmFit and from mbrpr are the same for poisson", {
  br1 <- summary(fit<-glm(counts ~ outcome + treatment, family = poisson(), method = "brglmFit",
                     type="AS_median"))
  X <- model.matrix(fit)
  y <- fit$y
  br2 <- mbrpr(par=rep(0,ncol(X)),y=y,X=X,eps = 1e-10,maxit=500)
  c1 <- coef(br1)[,c(1,2)]
  dimnames(c1)=NULL
  c2 <- cbind(br2$coefficients,sqrt(diag(br2$InfoInv)))
  expect_equal(c1,c2, tolerance = tol)
})

