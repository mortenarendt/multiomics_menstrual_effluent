library(tidyverse)
library(hdf5r)
data <- R.matlab::readMat("~/Dropbox/Bekzod&Isabella/NMR data/Final files/nmrdata_NOESY_ME_YY.mat")

# export
nmr <- data$nmrdata.NOESY.ME.YY[[1]] %>% as.matrix()
ppm <- data$nmrdata.NOESY.ME.YY[[3]] %>% as.vector()
sample <- data$nmrdata.NOESY.ME.YY[[2]] %>% unlist() %>% as.vector()

f <- H5File$new('~/OneDrive - University of Copenhagen/KU_work/menstrual_effluent/multiomics_menstrual_effluent/rawdata/NMR_ME.h5', mode = "w")  # Overwrites if it exists

f$create_dataset(
  name = "matrix",
  robj = nmr,
  chunk_dims = c(117, 1024),
  gzip_level = 9
)

f$close_all()

write_csv(x = data.frame(ppm= ppm),file = '~/OneDrive - University of Copenhagen/KU_work/menstrual_effluent/multiomics_menstrual_effluent/rawdata/NMR_ME_ppm.csv') 

write_csv(x = data.frame(sample= sample),file = '~/OneDrive - University of Copenhagen/KU_work/menstrual_effluent/multiomics_menstrual_effluent/rawdata/NMR_ME_sampleid.csv') 

rm(list = ls())
dataPB <- R.matlab::readMat("~/Dropbox/Bekzod&Isabella/NMR data/Final files/nmrdata_NOESY_PB_YY.mat")

# export
nmr <- dataPB$nmrdata.NOESY.PB.YY[[1]] %>% as.matrix()
ppm <- dataPB$nmrdata.NOESY.PB.YY[[3]] %>% as.vector()
sample <- dataPB$nmrdata.NOESY.PB.YY[[2]] %>% unlist() %>% as.vector()
dim(nmr)

f <- H5File$new('~/OneDrive - University of Copenhagen/KU_work/menstrual_effluent/multiomics_menstrual_effluent/rawdata/NMR_PB.h5', mode = "w")  # Overwrites if it exists

f$create_dataset(
  name = "matrix",
  robj = nmr,
  chunk_dims = c(43, 1024),
  gzip_level = 9
)

f$close_all()

write_csv(x = data.frame(ppm= ppm),file = '~/OneDrive - University of Copenhagen/KU_work/menstrual_effluent/multiomics_menstrual_effluent/rawdata/NMR_PB_ppm.csv') 

write_csv(x = data.frame(sample= sample),file = '~/OneDrive - University of Copenhagen/KU_work/menstrual_effluent/multiomics_menstrual_effluent/rawdata/NMR_PB_sampleid.csv') 

























f <- H5File$new('~/OneDrive - University of Copenhagen/KU_work/menstrual_effluent/multiomics_menstrual_effluent/rawdata/NMR_ME.h5', mode = "w")  # Overwrites if it exists

f$create_dataset(
  name = "matrix",
  robj = nmr,
  chunk_dims = c(117, 1024),
  gzip_level = 9
)

f$close_all())

f <- H5File$new('~/OneDrive - University of Copenhagen/KU_work/menstrual_effluent/multiomics_menstrual_effluent/rawdata/NMR_ME.h5', mode = "w")  # Overwrites if it exists

f$create_dataset(
  name = "matrix",
  robj = nmr,
  chunk_dims = c(117, 1024),
  gzip_level = 9
)

f$close_all()


f2 <- H5File$new('~/OneDrive - University of Copenhagen/KU_work/menstrual_effluent/multiomics_menstrual_effluent/rawdata/NMR_ME.h5', mode = "r")
mat <- f2[["matrix"]][, ]
f$close_all()

