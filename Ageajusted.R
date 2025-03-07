```{r}
library("epitools")
library("dplyr")
```


```{r}
age_groups <- c("15-19 years", "20-24 years", "25-29 years", "30-34 years", "35-39 years", "40-44 years", "45-49 years")
rates <- c(15.35108987, 37.36613749, 97.45666269, 241.6664959, 465.0025842, 744.3700305, 1000.915825)
std_pop <- c(84670.3653721198, 82171.2400659769, 79272.2547108512, 76073.3743189884, 71474.9837556855, 65876.9430699255, 60378.8673964113)
cases <- rates * std_pop  # Calculate the number of cases from rates

# Create a data frame
data <- data.frame(
  age_group = age_groups,
  cases = cases,
  population = std_pop
)

# Use the ageadjust.direct function to calculate the age-adjusted rate and confidence interval
result <- ageadjust.direct(count = data$cases, pop = data$population, stdpop = data$population)

# Print the result
print(result)

```


```{r}

```


```{r}
age_groups <- c("20-24 years", "25-29 years", "30-34 years", "35-39 years", "40-44 years", "45-49 years")
std_pop <- c(82171.2400659769, 79272.2547108512, 76073.3743189884, 71474.9837556855, 65876.9430699255, 60378.8673964113)

rates <- c(0.037287379,
           0.087503919,
           0.15879755,
           0.257012353,
           0.592792406,
           1.176769093)
cases <- rates * std_pop  # Calculate the number of cases from rates

# Create a data frame
data <- data.frame(
  age_group = age_groups,
  cases = cases,
  population = std_pop
)

# Use the ageadjust.direct function to calculate the age-adjusted rate and confidence interval
result <- ageadjust.direct(count = data$cases, pop = data$population, stdpop = data$population)

# Print the result
print(result)
```


```{r}
install.packages("BAPC", repos = "http://R-Forge.R-project.org")
library(BAPC)
library(bamp)
install.packages("INLA", repos = "https://inla.r-inla-download.org/R/stable", dependencies = TRUE)
library(INLA)
```


```{r}

```


```{r}
library(Epi)
breast_incident <- read.csv("/Users/cristochow/Desktop/daily_work/task_15/forecast/1990_2021_breast_incident.csv")
population <- read.csv("/Users/cristochow/Desktop/daily_work/task_15/forecast/population3.csv")

# Ensure that all relevant data is numeric
breast_incident[, -1] <- lapply(breast_incident[, -1], as.numeric)
population[, -1] <- lapply(population[, -1], as.numeric)

# Function to remove 'X' prefix and convert to numeric
clean_and_convert <- function(df) {
  # Remove 'X' prefix from column names
  names(df) <- gsub("^X", "", names(df))
  
  # Convert all columns except the first one to numeric
  df[,-1] <- lapply(df[,-1], function(x) as.numeric(as.character(x)))
  
  return(df)
}

# Apply the function to both dataframes
breast_incident <- clean_and_convert(breast_incident)
population <- clean_and_convert(population)

# Define standard weights for age-standardization
wstand <- c(0.163, 0.158, 0.153, 0.146, 0.137, 0.127, 0.116)


# Set the 'year' column as row names in 'sample'
rownames(breast_incident) <- breast_incident$year
breast_incident <- breast_incident[, -1]

rownames(population) <- population$year
population <- population[, -1]

sample_pro <- matrix(data = NA, nrow = 9, ncol = 7) %>% as.data.frame()
rownames(sample_pro) <- seq(2022, 2030, 1)
colnames(sample_pro) <- c("15_19", "20_24", "25_29", "30_34", "35_39", "40_44", "45_49")

# Combine the data frames using rbind
breast_incident <- rbind(breast_incident, sample_pro)

# Create APCList object
lc_esoph_1 <- APCList(breast_incident, population, gf = 5)

# Perform Bayesian Age-Period-Cohort analysis
bapc_result1 <- BAPC(
  lc_esoph_1,
  predict = list(npredict = 10, retro = TRUE),
  secondDiff = FALSE,
  stdweight = wstand,
  verbose = TRUE
)

plotBAPC(bapc_result1, 
         scale = 10^5, 
         type = 'ageStdRate', 
         showdata = TRUE
)

```



```{r}
slotNames(bapc_result1)

# 1) Extract Observed and Projected Means
obs_all <- bapc_result1@stdobs
fit_proj <- bapc_result1@agestd.proj[, "mean"]

# 2) Align by Common Years
common_years_proj <- intersect(names(obs_all), rownames(bapc_result1@agestd.proj))
obs_proj <- obs_all[common_years_proj]
fit_proj <- fit_proj[common_years_proj]

# 3) Compute Error Metrics
MSE_proj  <- mean((obs_proj - fit_proj)^2, na.rm = TRUE)
RMSE_proj <- sqrt(MSE_proj)
MAE_proj  <- mean(abs(obs_proj - fit_proj), na.rm = TRUE)

# WARNING: If obs_proj includes zeros, MAPE can be Inf
MAPE_proj <- mean(abs(obs_proj - fit_proj) / obs_proj, na.rm = TRUE) * 100

# 4) Print Results
cat("=== Projected Accuracy Metrics (Years in Overlap) ===\n")
cat("MSE:   ", MSE_proj,  "\n")
cat("RMSE:  ", RMSE_proj, "\n")
cat("MAE:   ", MAE_proj,  "\n")
cat("MAPE:  ", MAPE_proj, "%\n\n")

```


```{r}
non_zero_idx <- which(obs_proj > 0)
MAPE_proj_no_zeros <- mean(
  abs(obs_proj[non_zero_idx] - fit_proj[non_zero_idx]) / obs_proj[non_zero_idx],
  na.rm = TRUE
) * 100
cat("MAPE (excluding zero obs):", MAPE_proj_no_zeros, "%\n")
```