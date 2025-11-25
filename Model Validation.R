
## Model Validation on 20% Test Data (R_tick)

library(dplyr)
library(ggplot2)

sf_log <- model_lognorm_r$summary.fitted.values  # already on log scale

val_log <- tibble(
  district   = merged_sf$ADM2_EN,
  obs_log    = log_r_tick_orig,
  pred_log   = sf_log$mean,
  lo_log     = sf_log$`0.025quant`,
  hi_log     = sf_log$`0.975quant`,
  split      = merged_sf$cv_split_r
) %>% 
  filter(split == "test") %>% 
  arrange(pred_log) %>%
  mutate(district = factor(district, levels = district))

validation_r <- ggplot(val_log, aes(x = district)) +
  # 95% credible interval box (orange, no border)
  geom_rect(
    aes(xmin = as.numeric(district) - 0.25,
        xmax = as.numeric(district) + 0.25,
        ymin = lo_log, ymax = hi_log),
    fill = "gray",
    color = NA,
    alpha = 0.6
  ) +
  # Mean as a horizontal line inside the box
  geom_segment(
    aes(x = as.numeric(district) - 0.25,
        xend = as.numeric(district) + 0.25,
        y = pred_log, yend = pred_log),
    color = "black", linewidth = 0.8
  ) +
  # Observed point (red)
  geom_point(aes(y = obs_log), color = "red", size = 2) +
  labs(
    x = "District",
    y = expression(log(italic(R.~microplus)))
  ) +
  scale_y_continuous(limits = c(0, 15)) +
  theme_classic(base_size = 13) +
  theme(
    panel.border     = element_rect(color = "black", fill = NA, linewidth = 0.8),
    panel.grid       = element_blank(),
    panel.background = element_rect(fill = "white", color = NA),
    plot.background  = element_rect(fill = "white", color = NA),
    axis.text.x      = element_text(angle = 45, hjust = 1)
  )

print(validation_r)





## Model Validation on 20% Test Data (H_tick)

library(dplyr)
library(ggplot2)

sf_log <- model_lognorm_h$summary.fitted.values  # already on log scale

val_log <- tibble(
  district   = merged_sf$ADM2_EN,
  obs_log    = log_h_tick_orig,
  pred_log   = sf_log$mean,
  lo_log     = sf_log$`0.025quant`,
  hi_log     = sf_log$`0.975quant`,
  split      = merged_sf$cv_split_h
) %>% 
  filter(split == "test") %>% 
  arrange(pred_log) %>%
  mutate(district = factor(district, levels = district))

validation_h <- ggplot(val_log, aes(x = district)) +
  # 95% credible interval boxes (red4, no border)
  geom_rect(
    aes(xmin = as.numeric(district) - 0.25,
        xmax = as.numeric(district) + 0.25,
        ymin = lo_log, ymax = hi_log),
    fill = "gray",
    color = NA,
    alpha = 0.6
  ) +
  # Mean as horizontal line inside each box
  geom_segment(
    aes(x = as.numeric(district) - 0.25,
        xend = as.numeric(district) + 0.25,
        y = pred_log, yend = pred_log),
    color = "black", linewidth = 0.8
  ) +
  # Observed data points (red)
  geom_point(aes(y = obs_log), color = "red", size = 2) +
  labs(
    x = "District",
    y = expression(log(italic(H.~anatolicum)))
  ) +
  scale_y_continuous(limits = c(0, 15)) +
  theme_classic(base_size = 13) +
  theme(
    panel.border     = element_rect(color = "black", fill = NA, linewidth = 0.8),
    panel.grid       = element_blank(),
    panel.background = element_rect(fill = "white", color = NA),
    plot.background  = element_rect(fill = "white", color = NA),
    axis.text.x      = element_text(angle = 45, hjust = 1)
  )

print(validation_h)
