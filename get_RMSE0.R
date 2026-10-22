# Compute loio RMSE0
rm(list = ls())
library(phyloseq)
load('~/OneDrive - University of Copenhagen/KU_work/menstrual_effluent/multiomics_menstrual_effluent/MEdata.RData')
phyXpp <- phyX %>% 
  subset_samples(!is.na(Sample.ID)) %>% 
  subset_samples(!is.na(X2.hydroxyisovaleric.acid)) %>% 
  transform_sample_counts(function(x) x / sum(x)) %>% 
  filter_taxa(function(x) sum(x > 0)>10, TRUE) 

Y <- phyXpp@sam_data %>% data.frame() %>% dplyr::select(-TSP,-ERECTIC)

c <- 0
CVindex <- list()
for (i in unique(Y$Participant)) {
  c <- c+1
  CVindex[[c]] <- which(Y$Participant!=i)
}

RMSE0 <- data.frame()

unmet <- unique(MEconc_newlong$met) 
unmet <- unmet[!(unmet %in% c("ERECTIC","TSP"))]
for (i in unmet){
  
  # i <- unmet[1]
  print(i)
  # y <- Y[,i]
  
  yy <- MEconc_newlong %>% filter(met==i) %>% filter(!is.na(Participant)) %>% filter(`Blood origen`=='ME') 
  
  YY <- Y %>% 
    left_join(yy, by = c('Participant','Period','Cycle.day' = 'Cycle day'))
  
  y <- YY$logy
  sdy <- sd(y)
  
  
  yhat <- y
  for (ii in 1:18){
    notin <- logical(length(y))
    notin[CVindex[[ii]]] <- TRUE
    # print(mean(y[notin]))
    yhat[!notin] <- mean(y[notin])
  }
  e <- y - yhat
  RMSE0 <- bind_rows(RMSE0,data.frame(rmse0 = caret::RMSE(yhat,y), 
                      sdy = sd(y), 
                      metabolite = i))
}
save(file = '~/OneDrive - University of Copenhagen/KU_work/menstrual_effluent/multiomics_menstrual_effluent/RMSE0_loio.RData',list = c('RMSE0'))
