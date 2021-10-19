###------------- Create Cluster Genomewide Heatmap ------###

#----Thomas van Ravesteyn, t.ravesteyn@hubrecht.eu
#----Kops Group
#----Hubrecht Institute

###---------------- Load dependencies ------------------###
###-----------------------------------------------------###

library(AneuFinder)
library(colorspace)


###--------------- Settings before start ---------------###
###-----------------------------------------------------###

#Set input directory, each folder representing a sample containing Aneufinder output
input_dir <- c("Input/Selected_lines for cluster")

#set output file name, should end with ".pdf".
output_file_name <- c(paste0("Output/", Sys.Date(), "_genomewide_cluster_plot.pdf"))

#set if your individual cells originate from multiple library plates (if TRUE, model identifiers will be appended with sample name)
multiple_plates <- TRUE


###---------------Collect files to analyze --------------------------------###
###------------------------------------------------------------------------###

#Collect all sample names in working directory
sampleIDs <- list.files(path = input_dir, pattern = "")

#Select subset of samples (optional)
#sampleIDs <- sampleIDs[1:2]

#create empty objects
hmmFiles <- list()
dnaFiles <- list()
edivisiveFiles <- list()


###-------------------- CHOOSE TYPE OF FILE SOURCE ------------------------###
###------------------------------------------------------------------------###

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

###--------------------------------- OR -----------------------------------###

###-------- C. Collect Files from subfolder in working directory-----------###

for(sample in sampleIDs) {
  hmmFiles[[sample]] <- list.files(sample, full = TRUE)
  dnaFiles[[sample]] <- list.files(sample, full = TRUE)
  edivisiveFiles[[sample]] <- list.files(sample, full = TRUE)
}


###-------- Create vectors required for clustered heatmap -----------------###
###------------------------------------------------------------------------###

#select model type to analyze, choose 1 (hmmFiles / dnaFiles / edivisiveFiles)
#myFiles <- hmmFiles
myFiles <- dnaFiles
#myFiles <- edivisiveFiles

#create single vector with all selected Files
my_selected_Files <- unlist(myFiles)

#Determine number of cells for each sample
my_class_length <- c()
for (sample in sampleIDs){
  my_class_length <- append(my_class_length, length(myFiles[[sample]]))  
}

#create vector with all classes behind each other
my_classes <- c()
for (i in 1:length(sampleIDs)){
  my_classes <- append(my_classes, rep(sampleIDs[i], times = my_class_length[i]))
}

#create number of colors corresponding to number of classes
my_colors <- qualitative_hcl((length(unique(my_classes))), palette = "Dark 3")

#rewrite model IDs in Aneufinder model files to enable clustering of cells from different plates
if (multiple_plates == TRUE){
  for (i in 1:length(my_selected_Files)){
    #load model
    load(my_selected_Files[i])
    #add sample name to model ID
    model$ID <- c(paste0(my_classes[i],"_",model$ID))
    #save model file
    save(model, file = my_selected_Files[i])
  }
}
 
###----------------- Create clustered genomewide heatmap ------------------###
###------------------------------------------------------------------------###
 
#create genomewide heatmap with all cells, save to working directory
heatmapGenomewide(my_selected_Files, 
                  classes = my_classes, classes.color = my_colors, 
                  reorder.by.class = T,  cluster = T,
                  file = output_file_name)
