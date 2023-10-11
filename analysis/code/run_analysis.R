# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: automatic imitation  
# Author: Simeon Q. Smeele
# Description: Runs the analysis.
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('cmdstanr', 'rethinking')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_data = 'analysis/data/dummy_data.csv'
path_model_trials = 'analysis/code/model_trials.stan'
path_model_latency = 'analysis/code/model_latency.stan'
path_results_trials = 'analysis/results/results_trials.RData'
path_results_latency = 'analysis/results/results_latency.RData'

# Read data
dat = read.csv2(path_data)

# Prepare data for trial model
clean_dat = list(N_obs = nrow(dat),
                 N_ind = length(unique(dat$Individual)),
                 N_beh = length(unique(dat$Behaviours)),
                 group = as.integer(as.factor(dat$Group)),
                 ind = as.integer(as.factor(dat$Individual)),
                 beh = as.integer(as.factor(dat$Behaviours)),
                 response = as.integer(dat$Response))

# Run trial model
model = cmdstan_model(path_model_trials)
fit = model$sample(data = clean_dat, 
                   seed = 1, 
                   chains = 4, 
                   parallel_chains = 4,
                   refresh = 500) 
fit_nice = fit$output_files() |>
  rstan::read_stan_csv()
print(precis(fit_nice))

# Save output latency
save(fit_nice, file = path_results_latency)

# Prepare data for latency model
clean_dat = list(N_obs = nrow(dat),
                 N_ind = length(unique(dat$Individual)),
                 N_beh = length(unique(dat$Behaviours)),
                 group = as.integer(as.factor(dat$Group)),
                 ind = as.integer(as.factor(dat$Individual)),
                 beh = as.integer(as.factor(dat$Behaviours)),
                 latency = log(dat$Latency))

# Run latency model
model = cmdstan_model(path_model_latency)
fit = model$sample(data = clean_dat, 
                   seed = 1, 
                   chains = 4, 
                   parallel_chains = 4,
                   refresh = 500,
                   adapt_delta = 0.99) 
fit_nice = fit$output_files() |>
  rstan::read_stan_csv()
print(precis(fit_nice))

# Save output latency
save(fit_nice, file = path_results_latency)
