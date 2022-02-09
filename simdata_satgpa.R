# Simulated data with Synthpop

# Initialise synthpop package
library(synthpop)
library(ABSsimulateddata)
library(semTools)

# Other Packages
library(purrr)
library(dplyr)


infolder <- "C:/Users/ryanjm/Documents/Synthetic Data Challenge/"

ods <- read.csv( paste0(infolder,"satgpa.csv"), header = TRUE ) %>%
  mutate( sex=as.factor(sex) )


### NEW FUNCTIONS
# Simulated_continuous_f
# Simulated_categorical_f
# Parameters_categorical_f
# Plot_multibars_f



###

sim_object <- Simulatedata_continous_f(ods %>% select(-sat_sum), seed=123,
                                       negatives = TRUE) %>%
  mutate(sat_sum=sat_v+sat_m)

head(sim_object)
syn_cat_obj <- Synthpop_categorical_f(df=data.frame(sex=ods$sex,sim_object),
                                      v.sequence=
                                        Visits_permutation_f(user=matrix(rbind(c(1,5,4,2,3,6),c(6:1)),nrow=2),n=5),
                                      syn.method="cart", m=1, y="sex",
                                      best.method="pSCORE")

syn_combined <- cbind(sex=syn_cat_obj$sex,sim_object) %>% 
  mutate(sat_v=round(sat_v,digits=0) ) %>%
  mutate(sat_m=round(sat_m,digits=0) ) %>%
  mutate(sat_sum=sat_v+sat_m) %>%
  mutate(hs_gpa=round(hs_gpa,digits=2) ) %>%
  mutate(fy_gpa=round(fy_gpa,digits=2) ) 

utility.tables(syn_combined, ods, tables = "twoway", tab.stats="all")

# Manually check for duplicates

# Unique records in original dataset

ods_uniques <- ods[!duplicated(ods),]

semi_join(ods_uniques,syn_combined)


