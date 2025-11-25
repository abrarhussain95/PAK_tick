## PCA

library(factoextra)
library(ggplot2)
library(ggbiplot)
library(dplyr)
library(sf)

# Step 1: Prepare data
env_data <- merged_sf %>%
  st_drop_geometry() %>%
  dplyr::select(ADM2_EN, mean_temp, mean_precip, mean_rh, mean_elev) %>%
  mutate(across(c(mean_temp, mean_precip, mean_rh, mean_elev), 
                ~ as.numeric(as.character(.))))

# Step 2: Fill any NAs with column means (just in case)
env_filled <- env_data %>%
  mutate(across(c(mean_temp, mean_precip, mean_rh, mean_elev), 
                ~ ifelse(is.na(.), mean(., na.rm = TRUE), .)))
# Step 3: Run PCA
env_vars <- env_filled[, c("mean_temp", "mean_precip", "mean_rh", "mean_elev")]
pca_result <- prcomp(env_vars, center = TRUE, scale. = TRUE)

# Step 4: Get scores for all rows
pca_scores <- as.data.frame(pca_result$x[, 1:4])
colnames(pca_scores) <- c("PC1", "PC2", "PC3", "PC4")
pca_scores$ADM2_EN <- env_filled$ADM2_EN

# Step 5: Join scores back to merged_sf using ADM2_EN
merged_sf <- left_join(merged_sf, pca_scores, by = "ADM2_EN")

summary(pca_result)

#View(merged_sf)


#elements in PCA
names(pca_result)

#SD of PCA components
pca_result$sdev

#Eigenvectors or PCA
pca_result$rotation

#SD and mean of variables
pca_result$center
pca_result$scale

#Principle Component scores
pca_result$x


##Visualization

# Scree plot of variance
screeplot <- fviz_eig(pca_result, 
                      addlabels = TRUE, 
                      ylim = c(0, 100)) +  
  theme_bw() +        
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

print(screeplot)





# Biplot with colored provinces
biplot <- fviz_pca_var(pca_result,
                       col.var = "cos2",
                       gradient.cols = c("red", "blue", "green"),
                       repel = TRUE) +
  scale_color_gradientn(
    colors = c("red", "blue", "green"),
    breaks = c(0.25, 0.50, 0.75),
    limits = c(0, 1)
  ) +
  labs(color = "Correlation") + 
  theme_bw() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank())

print(biplot)



