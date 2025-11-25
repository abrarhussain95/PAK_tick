Project Overview: Spatial Modeling of R. microplus & H. anatolicum

This project analyzes the district-level abundance of two tick species (Rhipicephalus microplus and Hyalomma anatolicum) in Punjab and Khyber Pakhtunkhwa using environmental factors, livestock density, and Bayesian spatial methods. The workflow includes PCA for dimensionality reduction, non-spatial regression, spatial modeling with INLA (BYM2), model validation, and prediction for unsampled districts.

1. Data

District-level tick counts aggregated to “tick abundance per 100,000 animals per month.”

Environmental covariates: temperature, precipitation, elevation, and relative humidity.

Livestock and cattle density (smoothed).

The Pakistan district shapefile was joined to the dataset.

2. PCA (Principal Component Analysis)

Used to summarize correlated environmental variables into a smaller set of independent components.

PC1 and PC2 capture major gradients across temperature, humidity, precipitation, and elevation.

These PCs are used as predictors in all models to avoid multicollinearity.

3. Gaussian Regression (Non-spatial)

Log-transformed tick abundance is modeled with PC1 and PC2.

Shows moderate explanatory power.

Reveals which environmental gradients are linked to higher or lower tick abundance.

Residual plots indicate the presence of residual spatial structure, justifying the use of spatial modeling.

4. Bayesian Spatial Models (INLA, BYM2)

INLA’s BYM2 model accounts for district-to-district spatial dependence.

Outcome: log abundance of each tick species.

Predictors: PC1, PC2.

Random effect: spatial + independent noise.

Outputs include posterior means, credible intervals, and spatial hyperparameters.

Produces smoothed, spatially consistent estimates even in data-sparse regions.

5. Model Validation

Two approaches are used:
(a) 80/20 spatial split

20% of districts are held out.

Predicted credible intervals are compared to observed values.

Helps assess out-of-sample performance.

(b) Posterior predictive checks

CPO, PIT, and residual plots test calibration and identify potential misfits.

Spatial residual maps show remaining structure or missing covariates.

6. Prediction for Unsampled Districts

The final spatial model provides:

Posterior mean tick abundance (both species)

Lower and upper 95% credible intervals

Maps showing the predicted distribution across all districts
These outputs highlight potential high-risk areas where no field sampling data exists.


