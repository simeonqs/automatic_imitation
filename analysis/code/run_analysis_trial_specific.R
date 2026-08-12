# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: automatic imitation  
# Author: Simeon Q. Smeele
# Description: Runs the analysis.
# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

# Loading libraries
libraries = c('cmdstanr', 'rethinking', 'stringr')
for(lib in libraries){
  if(! lib %in% installed.packages()) lapply(lib, install.packages)
  lapply(libraries, require, character.only = TRUE)
}

# Clean R
rm(list=ls()) 

# Paths
path_data_specific = 'analysis/data/data_specific.csv'
path_model_trial = 'analysis/code/model_trial_ordinal.stan'
path_results = 'analysis/results/results_trial_specific.RData'

# Function to extract samples
extract.samples.cmdstanr <- function(fit_obj) {
  vars <- fit_obj$metadata()$stan_variables
  draws <- posterior::as_draws_rvars(fit_obj$draws())
  
  lapply(vars, \(var_name){  
    posterior::draws_of(draws[[var_name]], with_chains = FALSE)
  }) |> setNames(vars)
}

# Read data
dat = read.csv(path_data_specific, na.strings = c('?', ''))
dat = dat[!is.na(dat$Individual),]
dat$Behaviour = dat$Behaviour |> str_remove(' ')

# Prepare data for trial model
trans_group = c(Compatible = 1L, Incompatible = 2L)
trans_ind = c(Daisy = 1L, Debbie = 2L, Delphi = 3L, 
              Dobbie = 4L, Ivo = 5L, Pepina = 6L)
trans_beh = c(BellyUp = 1L, Spin = 2L, Splash = 3L, TailWave = 4L)
trans_beh_pair = c(BellyUp = 1L, Spin = 2L, Splash = 2L, TailWave = 1L)
clean_dat = list(N_obs = nrow(dat),
                 N_ind = length(unique(dat$Individual)),
                 N_beh = 4L,
                 N_session = max(as.integer(dat$Session)),
                 group = trans_group[dat$Group],
                 ind = trans_ind[dat$Individual],
                 beh = trans_beh[dat$Behaviour],
                 beh_pair = trans_beh_pair[dat$Behaviour],
                 session = as.integer(dat$Session),
                 response = as.integer(dat$Response))

# Run trial model
model = cmdstan_model(path_model_trial)
fit = model$sample(data = clean_dat, 
                   seed = 1, 
                   chains = 4, 
                   parallel_chains = 4,
                   refresh = 500) 
print(fit$summary(), n = 100)
post = extract.samples.cmdstanr(fit)

# Save output trial
save(fit, post, dat, clean_dat, trans_group, trans_ind, trans_beh, 
     file = path_results)