##### Combined Analysis #### 
library(synthpop)
library(purrr)
library(dplyr)

# Load in all required data
infolder <- "C:/Users/kooste/Documents/"

ods <- read.csv( paste0(infolder,"hgl_synth_challenge/original_data/satgpa.csv"), header = TRUE ) 

ods <- ods %>% mutate( sex=recode(ods$sex, "1" = "male", "2" = "female") ) %>%
  mutate( sex=as.factor(sex) )

gan_data <- read.csv(paste0(infolder,"hgl_synth_challenge/synth_data/","ctgan_method.csv"), header=TRUE) %>%
  select(-X)

gan_data <- gan_data %>% mutate( sex=recode(gan_data$sex, "1" = "male", "2" = "female") ) %>%
  mutate( sex=as.factor(sex) )


cart_data <- read.csv(paste0(infolder,"hgl_synth_challenge/synth_data/","synthpop_method.csv"), header=TRUE) %>%
  select(-X)

cart_data <- cart_data %>% mutate( sex=recode(cart_data$sex, "1" = "male", "2" = "female") ) %>%
  mutate( sex=as.factor(sex) )

sim_data <- read.csv(paste0(infolder,"hgl_synth_challenge/synth_data/","simdata.csv"), header=TRUE) %>%
  select(-X)

sim_data <- sim_data %>%
  mutate( sex=recode(sim_data$sex, "male" = "male", "female" = "female") ) %>%
  mutate( sex=as.factor(sex) ) %>%
  select(sex, sat_v, sat_m, sat_sum, hs_gpa, fy_gpa)

### Get statistics for comparison
# GAN Data
synthpop::compare(gan_data, ods, utility.stats = c("S_pMSE", "df"))

utility.tables(gan_data, ods, tab.stats="all", tables="twoway")

# Simulated Data
synthpop::compare(sim_data, ods, utility.stats = c("S_pMSE", "df"))

utility.tables(sim_data, ods, tab.stats="all", tables="twoway")

# CART Data
synthpop::compare(cart_data, ods, utility.stats = c("S_pMSE", "df"))

cart_obj <- utility.tables(cart_data, ods, tab.stats="all", tables="twoway")

### Plot, disclosure vs utility
# Numbers manually typed in from previous utility.tables outputs

plotnames <- c("Synthpop", "Simdata", "CTGAN")
med_PMSE <- 1-c(0.0016, 0.0027, 0.0098)
disclosure <- c(31/1000, 0 ,0)

plot(med_PMSE,disclosure, xlab="Utility", ylab="Risk")
text(disclosure~med_PMSE, labels = plotnames, pos=4)

### General PMSE scores
# GAN Data
utility.gen(gan_data, ods, method = "logit", maxorder = 1)
##      pMSE    S_pMSE 
##  0.024086 22.668925 
set.seed(42)
utility.gen(gan_data, ods, method = "cart", resamp.method = "perm", print.variable.importance = T)
##      pMSE   S_pMSE 
##  0.174851 4.552905

# Simulated Data
utility.gen(sim_data, ods, method = "logit", maxorder = 1)
##      pMSE    S_pMSE 
##  0.011416 10.744713
set.seed(42)
utility.gen(sim_data, ods, method = "cart", resamp.method = "perm", print.variable.importance = T)
##      pMSE   S_pMSE 
##  0.199173 5.204665

# CART Data
utility.gen(cart_data, ods, method = "logit", maxorder = 1)
##      pMSE   S_pMSE 
##  0.001567 1.475240
set.seed(42)
utility.gen(cart_data, ods, method = "cart", resamp.method = "perm", print.variable.importance = T)
##      pMSE   S_pMSE 
##  0.052178 1.541352 