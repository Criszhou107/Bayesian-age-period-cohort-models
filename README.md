# Bayesian age-period-cohort models

Package implementing Bayesian age-period-cohort models with the focus on projections. BAPC uses integrated nested Laplace approximations (INLA) for full Bayesian inference. BAPC generates age-specific and age-standardized projected rates. When interest lies in the predictive distribution, Poisson noise is automatically added. The INLA package can be obtained from http://www.r-inla.org . 


A Bayesian age-period-cohort model fitted using a Poisson model within INLA is used to project mortality or disease rates. Age, period and/or cohort effects are either modelled using a random walk of second order (RW2), or fixed effect (drift).


Bayesian inference for bivariate meta-analysis of diagnostic test studies using integrated nested Laplace approximation (INLA). A purpose built graphic user interface is available. The installation of the R package INLA is compulsory for successful usage. The INLA package can be obtained from . We recommend the testing version, which can be downloaded by running:

install.packages("INLA", repos="http://www.math.ntnu.no/inla/R/testing")

# BAPC results
![000012](https://github.com/user-attachments/assets/f054cb23-76e4-48c2-9eb3-413f468deec6)
