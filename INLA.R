## BYM2 (Besag-York-Mollié 2) Model Final (R_tick)

model_lognorm_r <- inla(
  log_r_tick_train ~ 
    PC1 + PC2 + 
    f(re_u, model = "bym2", graph = g, scale.model = TRUE),
  family = "gaussian",
  data = merged_sf,
  control.predictor = list(compute = TRUE),
  control.compute   = list(cpo = TRUE, dic = TRUE, waic = TRUE, config = TRUE),
  control.inla      = list(strategy = "laplace"),  # conservative, stable
  verbose = FALSE
)

summary(model_lognorm_r)

#Model improved  by lowering its DIC and WAIC 

#Significance
model_lognorm_r$summary.fixed
model_lognorm_r$summary.hyperpar


#Check for Poor Fit Using CPO (Conditional Predictive Ordinate)

# Check number of failures
table(model_lognorm_r$cpo$failure)

# Use -log(CPO): larger = worse predictive support
plot(-log(model_lognorm_r$cpo$cpo),
     main = "-log(CPO) (larger = worse fit)",
     ylab = "-log(CPO)", xlab = "Area index")


# PIT histogram: should be ~Uniform if calibrated
hist(model_lognorm_r$cpo$pit, breaks = 20, main = "PIT histogram", xlab = "PIT")

# This model is better calibrated in terms of predictive uncertainty

# Fitted & residuals (log scale)
fhat_log <- model_lognorm_r$summary.fitted.values$mean         
merged_sf$predicted_lognorm_r <- fhat_log                      
merged_sf$residuals_lognorm_r <- merged_sf$log_r_tick_train - fhat_log 

plot(merged_sf$predicted_lognorm_r, merged_sf$residuals_lognorm_r,
     main = "Residuals vs Fitted (log scale)",
     xlab = "Fitted log(R_tick)", ylab = "Residuals (log)")
abline(h = 0, col = "red")

# Our spatial + covariate model explains a fair portion of variation

# Map log-scale residuals 
library(tmap)
tm_shape(merged_sf) +
  tm_fill("residuals_lognorm_r", palette = "RdBu", style = "cont", title = "Residuals (log)") +
  tm_borders()

# Plot Marginal Posterior for PC1
plot(model_lognorm_r$marginals.fixed$PC1, type = "l",
     main = "Posterior for PC1", xlab = "Effect Size", ylab = "Density")
abline(v = 0, col = "red", lty = 2)

#|
#|


## BYM2 (Besag-York-Mollié 2) Model Final (H_tick)

model_lognorm_h <- inla(
  log_h_tick_train ~ 
    PC1 + PC2 + 
    f(re_u, model = "bym2", graph = g, scale.model = TRUE),
  family = "gaussian",
  data = merged_sf,
  control.predictor = list(compute = TRUE),
  control.compute   = list(cpo = TRUE, dic = TRUE, waic = TRUE, config = TRUE),
  control.inla      = list(strategy = "laplace"),  # conservative, stable
  verbose = FALSE
)

summary(model_lognorm_h)

#Model improved  by lowering its DIC and WAIC 

#Significance
model_lognorm_h$summary.fixed
model_lognorm_h$summary.hyperpar


#Check for Poor Fit Using CPO (Conditional Predictive Ordinate)

# Check number of failures
table(model_lognorm_h$cpo$failure)

# Use -log(CPO): larger = worse predictive support
plot(-log(model_lognorm_h$cpo$cpo),
     main = "-log(CPO) (larger = worse fit)",
     ylab = "-log(CPO)", xlab = "Area index")

# PIT histogram: should be ~Uniform if calibrated
hist(model_lognorm_h$cpo$pit, breaks = 20, main = "PIT histogram", xlab = "PIT")

# This model is better calibrated in terms of predictive uncertainty

# Fitted & residuals (log scale)
fhat_log <- model_lognorm_h$summary.fitted.values$mean         
merged_sf$predicted_lognorm_h <- fhat_log                      
merged_sf$residuals_lognorm_h <- merged_sf$log_h_tick_train - fhat_log  

plot(merged_sf$predicted_lognorm_h, merged_sf$residuals_lognorm_h,
     main = "Residuals vs Fitted (log scale)",
     xlab = "Fitted log(H_tick)", ylab = "Residuals (log)")
abline(h = 0, col = "red")

# Our spatial + covariate model explains a fair portion of variation

# Map log-scale residuals 
library(tmap)
tm_shape(merged_sf) +
  tm_fill("residuals_lognorm_h", palette = "RdBu", style = "cont", title = "Residuals (log)") +
  tm_borders()

# Plot Marginal Posterior for PC1
plot(model_lognorm_h$marginals.fixed$PC1, type = "l",
     main = "Posterior for PC1", xlab = "Effect Size", ylab = "Density")
abline(v = 0, col = "red", lty = 2)
