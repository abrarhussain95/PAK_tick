## Regression (R_tick)

# Gaussian regression 

library(dplyr)
library(gamlss)

#View(merged_sf)

# Drop geometry
merged_nogeo <- st_drop_geometry(merged_sf)

# Define desired columns
target_columns <- c("R_tick", "log_r_tick", "PC1", "PC2", "PC3", "PC4", 
                    "livestock_smoothed", "cattle_smoothed", "ADM2_EN")

# Filter to those that actually exist
existing_columns <- intersect(target_columns, names(merged_nogeo))

# Select only those
model_data <- dplyr::select(merged_nogeo, all_of(existing_columns))


# Fit standard Gamma model
library(gamlss)

#only using those rows which has non NA output variable
model_data <- model_data %>%
  filter(!is.na(R_tick))


#View(model_data)

#Model fitting
model_gamma <- gamlss(
  log_r_tick ~  PC1 + PC2,
  sigma.formula = ~1,
  family = NO(),  # Gamma distribution
  data = model_data
)

# View summary
summary(model_gamma)
# R2
Rsq(model_gamma)


#Residual Histogram & QQ Plot
hist(residuals(model_gamma, what = "z-scores"))
qqnorm(residuals(model_gamma, what = "z-scores")); qqline(residuals(model_gamma, what = "z-scores"))

# Inspect loading
loadings <- pca_result$rotation[, 1:2]  
round(loadings, 3)


#Plot Residuals Spatially

# Merge residuals into spatial data
model_data$resid <- residuals(model_gamma, what = "z-scores") 
merged_sf$resid <- model_data$resid[match(merged_sf$ADM2_EN, model_data$ADM2_EN)]



# Plot residuals
residuals_plot_R <- ggplot(merged_sf) +
  geom_sf(aes(fill = resid), color = "white", size = 0.2) +
  scale_fill_viridis_c(
    option = "plasma",           # use the plasma scheme
    direction = 1,               # 1 = normal order, -1 = reversed
    name = expression("Residuals of "*italic("R. microplus"))
  ) +
  theme(
    panel.background = element_rect(fill = "white"),
    plot.background = element_rect(fill = "white"),
    panel.grid = element_blank(),
    axis.ticks = element_blank()
  ) + theme_no_axes


print(residuals_plot_R)




## Regression  (H_tick)

# Gaussian regression 

library(dplyr)
library(gamlss)

#View(merged_sf)

# Drop geometry
merged_nogeo <- st_drop_geometry(merged_sf)

# Define desired columns
target_columns <- c("H_tick", "log_h_tick", "PC1", "PC2", "PC3", "PC4", 
                    "livestock_smoothed", "cattle_smoothed", "ADM2_EN")

# Filter to those that actually exist
existing_columns <- intersect(target_columns, names(merged_nogeo))

# Select only those
model_data <- dplyr::select(merged_nogeo, all_of(existing_columns))


# Fit standard Gamma model
library(gamlss)

#only using those rows which has non NA output variable
model_data <- model_data %>%
  filter(!is.na(H_tick))


#View(model_data)

#Model fitting
model_gamma <- gamlss(
  log_h_tick ~  PC1 + PC2 ,
  sigma.formula = ~1,
  family = NO(),  
  data = model_data
)

# View summary
summary(model_gamma)
# R2
Rsq(model_gamma)


#Residual Histogram & QQ Plot
hist(residuals(model_gamma, what = "z-scores"))
qqnorm(residuals(model_gamma, what = "z-scores")); qqline(residuals(model_gamma, what = "z-scores"))

# Inspect loading
loadings <- pca_result$rotation[, 1:2]  # PC1 and PC2 loading
round(loadings, 3)


#Plot Residuals Spatially

# Merge residuals into spatial data
model_data$resid <- residuals(model_gamma, what = "z-scores") 
merged_sf$resid <- model_data$resid[match(merged_sf$ADM2_EN, model_data$ADM2_EN)]



# Plot residuals
residuals_plot_H <- ggplot(merged_sf) +
  geom_sf(aes(fill = resid), color = "white", size = 0.2) +
  scale_fill_viridis_c(
    option = "plasma",        # "plasma" is the color scheme you mentioned
    direction = 1,            # 1 for normal, -1 to reverse
    name = expression("Residuals of "*italic("H. anatolicum"))
  ) +
  theme(
    panel.background = element_rect(fill = "white"),
    plot.background = element_rect(fill = "white"),
    panel.grid = element_blank(),
    axis.ticks = element_blank()
  ) + theme_no_axes


print(residuals_plot_H)

