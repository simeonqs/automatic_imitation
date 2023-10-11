# >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
# Project: automatic imitation  
# Author: Simeon Q. Smeele
# Description: Plots the results.
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
path_results_trials = 'analysis/results/results_trials.RData'
path_results_latency = 'analysis/results/results_latency.RData'
path_pdf_trials = 'analysis/results/results_trials.pdf'
path_pdf_latency = 'analysis/results/results_latency.pdf'

# Load data
dat = read.csv2(path_data)

# Plot trials
load(path_results_trials)
pdf(path_pdf_trials, 4, 4)
par(mfrow = c(1, 4), mar = c(4, 4, 4, 0))
layout(matrix(c(1, 1, 1, 2), 1, 4, byrow = TRUE))
plot(as.integer(as.factor(dat$Group)) + rnorm(nrow(dat), 0, 0.1),
     dat$Response + rnorm(nrow(dat), 0, 0.1),
     bty = 'n',
     pch = 16, col = '#85C1E9',
     xaxt = 'n', xlab = 'group',
     yaxt = 'n', ylab = 'response')
axis(1, c(1, 2), labels = c('compatible', 'incompatible'))
axis(2, c(0, 1), labels = c('incorrect', 'correct'))
post = extract.samples(fit_nice)
mean_a_group = inv_logit(apply(post$a_group, 2, mean))
pi_a_group = inv_logit(apply(post$a_group, 2, PI))
for(i in 1:2) lines(rep(i, 2), pi_a_group[,i])
points(mean_a_group, cex = 2, col = '#21618C', pch = 16)
points(mean_a_group, cex = 2)
d = density(post$cont)
d_flip = data.frame(d$y, d$x)
par(mar = c(4, 0, 4, 4))
plot(d_flip, bty = 'n', type = 'l', 
     ylim = c(-5, 5), xlim = c(1, 0),
     xaxt = 'n', yaxt = 'n',
     xlab = '', ylab = '')
polygon(d_flip, col = '#21618C')
abline(h = 0, lty = 2)
axis(4, c(-3, 0, 3), c(-3, 0, 3))
mtext('contrast', 4, 3, cex = 0.75)
dev.off()

# Plot latency
load(path_results_latency)
pdf(path_pdf_latency, 4, 4)
par(mfrow = c(1, 4), mar = c(4, 4, 4, 0))
layout(matrix(c(1, 1, 1, 2), 1, 4, byrow = TRUE))
plot(as.integer(as.factor(dat$Group)) + rnorm(nrow(dat), 0, 0.1),
     dat$Latency,
     ylim = c(0, 4),
     bty = 'n',
     pch = 16, col = '#85C1E9',
     xaxt = 'n', xlab = 'group',
     yaxt = 'n', ylab = 'latency')
axis(1, c(1, 2), labels = c('compatible', 'incompatible'))
axis(2, c(0, 2, 4))
post = extract.samples(fit_nice)
mean_a_group = exp(apply(post$a_group, 2, mean))
pi_a_group = exp(apply(post$a_group, 2, PI))
for(i in 1:2) lines(rep(i, 2), pi_a_group[,i])
points(mean_a_group, cex = 2, col = '#21618C', pch = 16)
points(mean_a_group, cex = 2)
d = density(post$cont)
d_flip = data.frame(d$y, d$x)
par(mar = c(4, 0, 4, 4))
plot(d_flip, bty = 'n', type = 'l', 
     ylim = c(-5, 5), xlim = c(3, 0),
     xaxt = 'n', yaxt = 'n',
     xlab = '', ylab = '')
polygon(d_flip, col = '#21618C')
abline(h = 0, lty = 2)
axis(4, c(-3, 0, 3), c(-3, 0, 3))
mtext('contrast', 4, 3, cex = 0.75)
dev.off()
