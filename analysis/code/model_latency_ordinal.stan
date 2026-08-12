// Automatic imitation
// Simeon Q. Smeele
// Description: Model to estimate the effect of experimental
// group on the latency. 

data{
  int N_obs;
  int N_ind;
  int N_beh;
  int N_session;
  array[N_obs] int group;
  array[N_obs] int ind;
  array[N_obs] int beh;
  array[N_obs] int beh_pair;
  array[N_obs] int session;
  array[N_obs] real log_latency;
}
parameters{
  real a_bar;
  matrix[2, 2] z_group;
  vector[N_ind] z_ind;
  vector[N_beh] z_beh;
  real<lower=0> sigma_group;
  real<lower=0> sigma_ind;
  real<lower=0> sigma_beh;
  matrix[2,2] learning;
  array[2, 2] simplex[N_session - 1] delta;
  real<lower=0> sigma;
}
model{
  vector[N_obs] mu;  
  a_bar ~ normal(0, 2);
  to_vector(z_group) ~ normal(0, 1);
  z_ind ~ normal(0, 1);
  z_beh ~ normal(0, 1);
  sigma_group ~ exponential(1);
  sigma_ind ~ exponential(1);
  sigma_beh ~ exponential(1);
  to_vector(learning) ~ normal(0, 1);
  for(g in 1:2){
    for(b in 1:2){
      delta[g, b] ~ dirichlet(
        rep_vector(1.0, N_session - 1)
      );
    }
  }
  sigma ~ exponential(1);
  for(i in 1:N_obs){
    real learn;
    learn = 0;
    for(s in 1:(session[i]-1)){
      learn += delta[group[i], beh_pair[i]][s];
    }
    mu[i] = a_bar + 
      z_group[group[i], beh_pair[i]] * sigma_group + 
      learning[group[i], beh_pair[i]] * learn +
      z_ind[ind[i]] * sigma_ind +
      z_beh[beh[i]] * sigma_beh;
  } 
  log_latency ~ normal(mu, sigma);
}
generated quantities{
  vector[2] intercept_cont;
  vector[2] learning_cont;
  intercept_cont =
    (z_group[1,] - z_group[2,])' * sigma_group;
  learning_cont =
    (learning[1,] - learning[2,])';
}
