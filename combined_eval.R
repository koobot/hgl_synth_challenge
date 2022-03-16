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

