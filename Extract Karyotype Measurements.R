###---------- Extract Karyotype Measurements ---------###

#----Thomas van Ravesteyn, t.ravesteyn@hubrecht.eu
#----Kops Group
#----Hubrecht Institute


###-------------- Load required packages -------------###
###---------------------------------------------------###

library(AneuFinder)
library(xlsx)


###--------------- Settings before start -------------###
###---------------------------------------------------###

#Set input directory, each folder representing a sample containing Aneufinder output
input_dir <- c("input/selected_lines")

#Collect all sample names
sampleIDs <- list.files(path = input_dir, pattern = "")

#create empty objects
hmmFiles <- list()
dnaFiles <- list()
edivisiveFiles <- list()

###-------------------- CHOOSE TYPE OF FILE SOURCE ------------------------###

###-------- A. Collect Files from UNFILTERED Aneufinder output ------------###
for(sample in sampleIDs) {
  hmmFiles[[sample]] <- list.files(paste0(input_dir,"/", sample, "/MODELS/method-HMM/"), full = TRUE)
  dnaFiles[[sample]] <- list.files(paste0(input_dir,"/",sample, "/MODELS/method-dnacopy/"), full = TRUE)
  edivisiveFiles[[sample]] <- list.files(paste0(input_dir,"/",sample, "/MODELS/method-edivisive/"), full = TRUE)
}

###--------------------------------- OR -----------------------------------###

###-------- B. Collect Files from AneufinderFileFilter output -------------###
for(sample in sampleIDs) {
  hmmFiles[[sample]] <- list.files(paste0(input_dir,"/",sample, "/QC_FILES_hmm/selected_model-files"), full = TRUE)
  dnaFiles[[sample]] <- list.files(paste0(input_dir,"/",sample, "/QC_FILES_dnaCopy/selected_model-files"), full = TRUE)
  edivisiveFiles[[sample]] <- list.files(paste0(input_dir,"/",sample, "/QC_FILES_edivisive/selected_model-files"), full = TRUE)
}


###------------ Collect Karyotype measurements--------###
###---------------------------------------------------###

#create empty dataframe to collect all measurements
my_karyoMeasurements <- data.frame()

for (sample in sampleIDs){
  
  #load Files and models based on selected model
  my_files <- dnaFiles
  models <- loadFromFiles(my_files[[sample]])
  
  #obtain karyotype measurements based on all models per sample
  my_karyoM <- karyotypeMeasures(models)
  temp_df <- my_karyoM$genomewide
  row.names(temp_df) <- sample
  
  #combine all measurements in a single table
  my_karyoMeasurements <- rbind(my_karyoMeasurements, temp_df)
}

#view first rows from karyotype measurements
head(my_karyoMeasurements)

#export as .xlsx
write.xlsx(my_karyoMeasurements, file = paste0("Output/", Sys.Date(), "my_Karyotype_Measurements.xlsx") , sheetName = "Sheet1", col.names = TRUE, row.names = TRUE, append = FALSE, showNA = FALSE)

#plot Karyotype measurements
my_plot <- ggplot(my_karyoMeasurements, aes(x=Aneuploidy, y= Heterogeneity, label = row.names(my_karyoMeasurements)))
my_plot + geom_point() +
  theme_minimal() +
  geom_text_repel(size = 3.5)
