#######################################
# Initialise
#######################################

# Initialise synthpop package
library(synthpop)

# Other Packages
library(purrr)
library(dplyr)
library(ABSsimulateddata)

infolder <- "C:/Users/ryanjm/Documents/Synthetic Data Challenge/"

ods <- read.csv( paste0(infolder,"satgpa.csv"), header = TRUE ) %>%
  mutate( sex=as.factor(sex) )

# Fix random numbers
set.seed(123)

# Create basic synthetic dataset in synthpop
syn_object <- syn(ods %>% select(-sat_sum), method=rep("cart",5))

syn_object$syn <- syn_object$syn %>% mutate(sat_sum=sat_v+sat_m)

syn_data <- syn_object$syn

#which(!(duplicated(syn_data) | duplicated(syn_data, 
                                     #fromLast = TRUE)))

#sdc_obj <- createSdcObj(dat=syn_data,keyVars="sex",numVars=colnames(syn_data[,-1]))

#### Synthpop code #####
#if (object$m == 1) {
#  if (!is.null(exclude)) 
#    Syn <- object$syn[, -exclude.cols, drop = FALSE]
  #else



#' duplicates_in_data
#'
#' @param orig_data A data frame of the orignal data the synthetic set is based from.
#' @param synth_data A data frame of the synthetic data. Must have same columns as original data
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

  print(no.duplicates)
  return( list(rm.Syn=rm.Syn, no.duplicates=no.duplicates) )
}

dup_out <- duplicates_in_data(ods,syn_data)

syn_data[dup_out$rm.Syn,]

#### END ####


# Synthpop quality metrics

unique_reps <- replicated.uniques(syn_object, ods, exclude = NULL)
print(paste("Number of Replicates = ", unique_reps$no.replications))

# Verify Manually
ods_uniques <- ods[!duplicated(ods),]

jacob_uniques <- semi_join(ods_uniques,syn_data)

# synthpop code from above
ods[dup.of.unique==TRUE,]


synthpop_uniques <- ods[unique_reps$replications,]

semi_join(ods[unique_reps$replications,],syn_data)



# Calculate propensity scores
utility.gen(syn_object, ods)

utility.tab(syn_object, ods , vars=c("sex","sat_v") )#,"sat_m","sat_sum","hs_gpa","fy_gpa")

synthpop::compare(syn_object, ods, utility.stats = c("S_pMSE", "df"))

utility.tables(syn_object, ods, tab.stats="all", tables="twoway")

# Manual propensity score calculation
# ods$syn_flag <- rep(0,dim(ods)[1])
# syn_data$syn_flag <- rep(1,dim(ods)[1])
# 
# mixed_dat <- rbind(ods, syn_data)
# 
# colnames(mixed_dat)
# fit <- glm(syn_flag ~ 0+sex+sat_v+sat_m+sat_sum+hs_gpa+fy_gpa,
#            family="binomial", data=mixed_dat)
# summary(fit)
# 
# dat_predictions <- predict.glm(fit,type="response")
# 
# pred_accuracy <- sum(ifelse(mixed_dat$syn_flag==(dat_predictions>0.5),1,0))
# print(pred_accuracy)

