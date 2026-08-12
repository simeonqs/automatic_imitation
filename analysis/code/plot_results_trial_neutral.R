# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: automatic imitation  
# Author: Simeon Q. Smeele
# Description: Plots the results of the ordinal trial model.
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
path_results = 'analysis/results/results_trial_neutral.RData'
path_pdf = 'analysis/results/results_trial_neutral.pdf'

# Load results
load(path_results)

# Settings
sessions = 1:clean_dat$N_session
groups = c('Compatible', 'Incompatible')
cols = c('#008B8B', '#00CED1')

# Function to calculate posterior predictions
get.predictions = function(beh_pair){
  
  out = list()
  
  for(g in 1:2){
    
    sessions = clean_dat$session[clean_dat$group == g] |> unique() |> sort()
    pred = matrix(NA, 
                  nrow = nrow(post$lp__), 
                  ncol = length(sessions))
    
    for(s in sessions){
      
      eta = post$a_bar[, 1] +
        post$z_group[, g, beh_pair] * post$sigma_group[, 1]

      # cumulative learning
      if(s > 1){
        for(k in 1:(s - 1)){
          eta = eta +
            post$learning[, g, beh_pair] *
            post$delta[, g, beh_pair, k]
        }
      }
      
      pred[, s] = inv_logit(eta)
    }
    
    out[[g]] = data.frame(
      session = sessions,
      mean = apply(pred, 2, mean),
      lower = apply(pred, 2, quantile, probs = 0.055),
      upper = apply(pred, 2, quantile, probs = 0.945),
      group = groups[g]
    )
  }
  
  do.call(rbind, out)
}


# Make plots
pdf(path_pdf, 12, 4)
par(mfrow = c(1, 2),
    mar = c(4, 4, 2, 1))

for(b in 1:2){
  
  pred = get.predictions(b)
  
  plot(NULL,
       xlim = range(sessions),
       ylim = c(0, 1),
       xlab = 'Session',
       ylab = 'Correct response rate',
       xaxt = 'n',
       bty = 'n')
  
  abline(h = 0.8, lty = 2, col = 'grey')

  axis(1, sessions)
  
  for(g in 1:2){
    
    tmp = pred[pred$group == groups[g], ]
    
    # credible interval
    arrows(tmp$session,
           tmp$lower,
           tmp$session,
           tmp$upper,
           length = 0.05,
           angle = 90,
           code = 3,
           col = cols[g])
    
    lines(tmp$session,
          tmp$mean,
          type = 'o',
          pch = c(16, 17)[g],
          lwd = 2,
          col = cols[g])
  }
  
  legend('bottomright',
         legend = groups,
         col = cols,
         pch = c(16, 17),
         lwd = 2,
         bty = 'n')
  
  title(c('Belly Up - Tail Wave', 'Spin - Splash')[b])
  
}

dev.off()