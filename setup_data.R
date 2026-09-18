# load and setup data for full publication

## TODO
## (Remove long format from files, and add gather() in the libs_init file)
### From ME objects
## _Samples Names_

### From phyloseq objects
## Remove _participant_, _Sample.name_, _samplenameold_ from phyloseq files, as this is the old code
## Remove _Barcode_,_Varioscan.c..c1._, _V1..h2o.volume._, _c2_, 
rm(list = ls())
load(file = '~/Dropbox/Bekzod&Isabella/Yongxin/data/tmp_import_dec2025.Rdata') # merged
rm(list = c('MEconc_newlong_old','PBconc_newlong_old','colorcodes','colorcodesnames','myround2'))

MEconc_new <- MEconc_new %>% 
  dplyr::select(`Samples #`,`Sample ID`,`Blood origen`,Batch,Participant:Period,Cycle,`Cycle day`:`Medication during sampling`,TSP:`bin-4`)

MEconc_newlong <- MEconc_newlong %>% 
  dplyr::select(`Samples #`,`Sample ID`,`Blood origen`,Batch,Participant:Period,Cycle,`Cycle day`:`Medication during sampling`,met,end_ppm:type,y,logy)

PBconc_new <- PBconc_new %>% 
  dplyr::select(`Samples #`,Sample,`Blood origen`,Batch,Participant:Period,Cycle,`Cycle day`:`Medication during sampling`, TSP:`bin-tyramine-tyrosine`)

PBconc_newlong <- PBconc_newlong %>% 
  dplyr::select(`Samples #`,Sample,`Blood origen`,Batch,Participant:Period,Cycle,`Cycle day`:`Medication during sampling`,met,end_ppm:type,y,logy)

load(file = '~/Dropbox/Bekzod&Isabella/16S_data/ME16s.RData')
load(file = '~/Dropbox/Bekzod&Isabella/ITS/ME_ITS.RData')

smd <- phyITS@sam_data %>% data.frame() %>% 
  dplyr::select(-participant,-Sample.name,-Batch,-samplenameold,-Barcode,-Varioscan.c..c1.,-V1..h2o.volume.,-c2) %>% dplyr::select(BRK,Position.on.plate,V2..µL.,Sample.ID,Blood.origen,Participant,Period,cycle,Cycle.day,day,cycle_day,cycle_part,Age:Medication.during.sampling,
                      TSP:bin.4) %>% sample_data()
phyITS@sam_data <- phyX@sam_data <- smd

rm(list = c('smd'))
save.image(file = '~/OneDrive - University of Copenhagen/KU_work/menstrual_effluent/multiomics_menstrual_effluent/MEdata.RData')
