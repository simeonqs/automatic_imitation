The R code and data needed to replicate results from the article:

```
reference
```

------------------------------------------------

**Abstract**

------------------------------------------------

**Requirements**

- R version 4.2.0 or later
- stringr: `install.packages("stringr")`
- Rethinking: for instructions and dependencies, see: 
  <https://github.com/rmcelreath/rethinking>
- cmdstanr: for instructions see Rethinking

------------------------------------------------

**Replicating the results**

Run all R scripts in `analysis/code` and all results should appear in the 
`analysis/results` directory. You can also rerun individual scripts since all 
intermediate and final results are already stored in the results directory. 
Data needed to reproduce the results are stored in `analysis/data` if you open 
RStudio from the `automatic_imitation.Rproj` file, you will start with the 
correct working directory and all paths will be correct relative to this 
working directory. Note that running the Stan models creates a compiled model 
file (without any extension) in the code folder. This can be deleted after the 
model is done running, or left there to safe time next time the model is run. 

------------------------------------------------

**Meta data**

- analysis/code
  - model_latency_ordinal.stan: Stan script with the model for latency
  - model_trial_ordinal.stan: Stan script with the model for performance per 
    trial
  - plot_results_latency_neutral.R: plots the results for the model for 
    latency in the experiment with neutral hand signal; requires 
    analysis/results/results_latency_neutral.RData and outputs 
    analysis/results/results_latency_neutral.pdf
  - plot_results_latency_specific.R: plots the results for the model for 
    latency in the experiment with specific hand signal; requires 
    analysis/results/results_latency_specific.RData and outputs 
    analysis/results/results_latency_specific.pdf
  - plot_results_trial_neutral.R: plots the results for the model for 
    performance per trial in the experiment with neutral hand signal; requires 
    analysis/results/results_trial_neutral.RData and outputs 
    analysis/results/results_trial_neutral.pdf
  - plot_results_trial_specific.R: plots the results for the model for 
    performance per trial in the experiment with specific hand signal; requires 
    analysis/results/results_trial_specific.RData and outputs 
    analysis/results/results_trial_specific.pdf
  - run_analysis_latency_neutral.R: runs the model for latency in the 
    experiment with neutral hand signal; requires 
    analysis/data/data_neutral.csv and outputs results to 
    analysis/results/results_latency_neutral.RData
  - run_analysis_latency_specific.R: runs the model for latency in the 
    experiment with specific hand signal; requires 
    analysis/data/data_specific.csv and outputs results to 
    analysis/results/results_latency_specific.RData
  - run_analysis_trial_neutral.R: runs the model for the performance in the 
    experiment with neutral hand signal; requires 
    analysis/data/data_neutral.csv and outputs results to 
    analysis/results/results_trial_neutral.RData
  - run_analysis_trial_specific.R: runs the model for the performance in the 
    experiment with specific hand signal; requires 
    analysis/data/data_specific.csv and outputs results to 
    analysis/results/results_trial_specific.RData
    
- analysis/data
  - data_neutral.csv: csv file with all data from the experiment with neutral 
    hand signal containing the following columns:
    - Date: date in dd/mm/yyyy
    - Session: session number as integer
    - Trial_S: trial number within session as integer
    - Trial: cumulative trial number (across sessions) as integer
    - Group: experimental group as string: Compatible, Incompatible
    - Individual: name of the focal individual as string: Daisy, Debbie, 
      Delphi, Dobbie, Ivo, Pepina
    - Behaviour: behaviour as string: Tail Wave, Belly Up, Spin, Splash; note
      typos are fixed in the script
    - Response: response as integer: 0, 1
    - Latency: latency to response in seconds as real number; note '?' is 
      handled as NA in the script
    - Comments: comments as string
  - data_specific.csv: csv file with all data from the experiment with specific 
    hand signal containing the following columns:
    - Date: date in dd/mm/yyyy
    - Session: session number as integer
    - Trial: trial number within session as integer
    - Trial_total: cumulative trial number (across sessions) as integer
    - Group: experimental group as string: Compatible, Incompatible
    - Individual: name of the focal individual as string: Daisy, Debbie, 
      Delphi, Dobbie, Ivo, Pepina
    - Behaviour: behaviour as string: Tail Wave, Belly Up, Spin, Splash; note
      typos are fixed in the script
    - Response: response as integer: 0, 1
    - Latency: latency to response in seconds as real number; note '?' is 
      handled as NA in the script
    - Comments: comments as string

- analysis/results
  - results_latency_neutral.pdf: pdf with the graphs for the model of latency 
    in the experiment with neutral hand signal
  - results_latency_neutral.RData: RData file with the results of the the 
    model of latency in the experiment with neutral hand signal; contains the 
    following R objects: 
    - clean_dat: list with all data for the Stan model
    - dat: data frame with data from the csv file (processed for errors)
    - fit: model fit
    - post: list with posterior samples from the model
    - trans_beh: named vector to translate behaviours into indices used in the 
      model
    - trans_group: named vector to translate experimental groups into indices 
      used in the model
    - tran_ind: named vector to translate individuals into indices used in the 
      model
  - results_latency_specific.pdf: pdf with the graphs for the model of latency 
    in the experiment with specific hand signal
  - results_latency_specific.RData: RData file with the results of the the 
    model of latency in the experiment with neutral hand signal; contains the 
    similar objects as results_latency_neutral.RData
  - results_trial_neutral.pdf: pdf with the graphs for the model of performance 
    per trial in the experiment with neutral hand signal
  - results_trial_neutral.RData: RData file with the results of the the 
    model of performance per trial in the experiment with neutral hand signal; 
    contains the similar objects as results_latency_neutral.RData
  - results_trial_specific.pdf: pdf with the graphs for the model of 
    performance per trial in the experiment with specific hand signal
  - results_trial_specific.RData: RData file with the results of the the 
    model of performance per trial in the experiment with specific hand signal; 
    contains the similar objects as results_latency_neutral.RData

------------------------------------------------

**System information**

All code was tested on the following system:

R version 4.6.1 (2026-06-24)
Platform: x86_64-pc-linux-gnu
Running under: Ubuntu 22.04.5 LTS
Packages: stringr_1.6.0, rethinking_2.42, cmdstanr_0.9.0, dependencies of those

------------------------------------------------

**Maintainers and contact**

Please contact Simeon Q. Smeele, <simeonqs@hotmail.com>, if you have any 
questions or suggestions. 