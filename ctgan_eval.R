# Script conducts quality evaluation on a synthetic dataset created with CTGAN

library(synthpop)
library(purrr)
library(dplyr)

infolder <- "C:/Users/ryanjm/Documents/Synthetic Data Challenge/"

ods <- read.csv( paste0(infolder,"satgpa.csv"), header = TRUE ) 

ods <- ods %>% mutate( sex=recode(ods$sex, "1" = "male", "2" = "female") ) %>%
  mutate( sex=as.factor(sex) )

gan_data <- read.csv(paste0(infolder,"hgl_synth_challenge/synth_data/","ctgan_method.csv"), header=TRUE) %>%
  select(-X)

gan_data <- gan_data %>% mutate( sex=recode(gan_data$sex, "1" = "male", "2" = "female") ) %>%
  mutate( sex=as.factor(sex) )

#' Function for counting duplicated records
#' duplicates_in_data
#'
#' @param orig_data A data frame of the original data the synthetic set is based from.
#' @param synth_data A data frame of the synthetic data. Must have same columns as original data
#' @description Function compares an original dataset with a synthetic version and counts
#' the records that are unique in the original dataset that were replicated uniquely in the synthetic data
#'  
#' @return 
duplicates_in_data <- function(orig_data,synth_data){
  
  # Get list of unique records in the original data
  uReal <- orig_data[!(duplicated(orig_data) | duplicated(orig_data, fromLast = TRUE)), 
                     , drop = FALSE]
  
  Syn <- synth_data
  rm.Syn <- rep(FALSE, nrow(Syn))
  # Unique recrds in the synthetic dataset
  i.unique.Syn <- which( !(duplicated(Syn) | duplicated(Syn, fromLast = TRUE)) )
  
  if (length(i.unique.Syn) != 0) {
    uSyn <- Syn[i.unique.Syn, , drop = FALSE]
    # Combine the list of uniques together
    uAll <- rbind.data.frame(uReal, uSyn)
    #' Check if combined dataset has duplicates, then output only the synthetic 
    #' part of the combined set
    dup.of.unique <- duplicated(uAll)[(nrow(uReal) + 
                                         1):nrow(uAll)]
    # map records from combined dataset to those from the synthetic dataset
    rm.Syn[i.unique.Syn] <- dup.of.unique
  }
  no.duplicates <- sum(rm.Syn) # Get number of duplicates
  
  return( list(replications=rm.Syn, no.duplicates=no.duplicates) )
}

dup_out <- duplicates_in_data(ods,gan_data)

gan_data[dup_out$replications,]

# Calculate propensity scores and other utility metrics

synthpop::compare(gan_data, ods, utility.stats = c("S_pMSE", "df"))

utility.tables(gan_data, ods, tab.stats="all", tables="twoway")



