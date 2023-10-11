// Automatic imitation
// Simeon Q. Smeele
// Description: Model to estimate the effect of experimental
// group on the latency. 

data{
  int N_obs;
  int N_ind;
  int N_beh;
  int group[N_obs];
  int ind[N_obs];
  int beh[N_obs];
  vector[N_obs] latency;
}
parameters{
  real a_bar;
  real<lower=0> sigma;
  vector[2] z_group;
  vector[N_ind] z_ind;
  vector[N_beh] z_beh;
  real<lower=0> sigma_group;
  real<lower=0> sigma_ind;
  real<lower=0> sigma_beh;
}
model{
  a_bar ~ normal(0.5, 0.5);
  sigma ~ exponential(2);
  z_group ~ normal(0, 1);
  z_ind ~ normal(0, 1);
  z_beh ~ normal(0, 1);
  sigma_group ~ exponential(2);
  sigma_ind ~ exponential(2);
  sigma_beh ~ exponential(2);
  latency ~ normal(a_bar + 
      z_group[group] * sigma_group + 
      z_ind[ind] * sigma_ind +
      z_beh[beh] * sigma_beh, sigma);
}
generated quantities{
  vector[2] a_group;
  real cont;
  a_group = z_group * sigma_group;
  cont = a_group[1] - a_group[2];
}
