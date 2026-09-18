# libs and initials

library(tidyr)
library(ggplot2)
library(dplyr)
library(stringr)
library(broom)
library(tidyverse)
library(broom.mixed)
library(lmerTest)
library(lme4)
library(ggtern)
library(magrittr)
library(pals)
library(phyloseq)
library(patchwork)
library(gt)
library(reactable)
library(vegan)
library(reactablefmtr)

### COLORS for omics types
colorcodes <- c('darkolivegreen','dodgerblue4','gold2','red3')
colorcodesnames <- c('ME-16s','ME-ITS','ME-NMR','PB-NMR')

#Creating a function which takes a numeric vector, rounds each non-missing value to a specified number of digits and returns a vector with these: 
myround2 <- function(x, digits = 3){
  idna <- !is.na(x)
  y <-as.character(x)
  
  intRound <- function(xx){
    c <- 0
    for (dgts in 3:5){
      c <- c+1
      if (c==1){
        if (xx < 10^-dgts) {yy <- paste('p <', 10^-dgts)} 
        else {yy <- paste('p =',as.character(ceiling(as.numeric(xx)*10^2)/10^2))}
      } else {
        if (xx < 10^-dgts) {yy <- paste('p <', 10^-dgts)} 
      }
    }
    return(yy)
  }
  
  y[idna] <- unlist(lapply(as.list(x[idna]),
                           function(x){intRound(x)}))
  y[!idna] <- ' '
  return(y)
}

load(file = '~/OneDrive - University of Copenhagen/KU_work/menstrual_effluent/multiomics_menstrual_effluent/MEdata.RData')

## Color codes for all
load(file = '~/OneDrive - University of Copenhagen/KU_work/menstrual_effluent/multiomics_menstrual_effluent/summarystats.RData')

colorvals <- unname(glasbey())
bsumITS$color <- bsum16s$color <- dflb$color <- '#D3D3D3'
dflb$color[1:8] <- colorvals[1:8]
bsumITS$color[1:8] <- colorvals[11:18]
bsum16s$color[1:8] <- colorvals[21:28]


