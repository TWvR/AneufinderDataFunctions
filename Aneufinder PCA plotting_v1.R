###------------- Aneufinder PCA plotting ------###

#----Thomas van Ravesteyn, t.ravesteyn@hubrecht.eu
#----Kops Group
#----Hubrecht Institute

###---------------- Load dependencies ------------------###
###-----------------------------------------------------###

library(AneuFinder)
library(colorspace)


###---------------Settings before start, unfiltered Aneufinder Output----------------###
###----------------------------------------------------------------------------------###


#Set input directory, each folder representing a sample containing Aneufinder output
input_dir <- c("input/selected_lines")

#Collect all sample names
sampleIDs <- list.files(path = input_dir, pattern = "")

#create empty objects
hmmFiles <- list()
dnaFiles <- list()
edivisiveFiles <- list()

###--------------------- Collect Files from Aneufinder output ---------------------###
###--------------------------------------------------------------------------------###

#Collect Files from Aneufinder output
for(sample in sampleIDs) {
  hmmFiles[[sample]] <- list.files(paste0(input_dir,"/", sample, "/MODELS/method-HMM/"), full = TRUE)
  dnaFiles[[sample]] <- list.files(paste0(input_dir,"/",sample, "/MODELS/method-dnacopy/"), full = TRUE)
  edivisiveFiles[[sample]] <- list.files(paste0(input_dir,"/",sample, "/MODELS/method-edivisive/"), full = TRUE)
}

###------------------------------------- OR ---------------------------------------###


###------------- Collect Files from AneufinderFileFilter output -------------------###
###--------------------------------------------------------------------------------###

#Collect Files from AneufinderFileFilter output
for(sample in sampleIDs) {
  hmmFiles[[sample]] <- list.files(paste0(input_dir,"/",sample, "/QC_FILES_hmm/selected_model-files"), full = TRUE)
  dnaFiles[[sample]] <- list.files(paste0(input_dir,"/",sample, "/QC_FILES_dnaCopy/selected_model-files"), full = TRUE)
  edivisiveFiles[[sample]] <- list.files(paste0(input_dir,"/",sample, "/QC_FILES_edivisive/selected_model-files"), full = TRUE)
}


###--------------- Generate and save PCA plots ----------------###
###------------------------------------------------------------###

##select model files of interest; hmm/dna/edivisive
#my_files <- hmmFiles
my_files <- dnaFiles
#my_files <- edivisiveFiles

#create appropriate classes and labels
classes <- c()
labels <-c()
for(sample in sampleIDs) {
  classes <- append(classes, c(rep(sample, length(my_files[[sample]]))))
  labels <- append(labels, c(paste(sample,1:length(my_files[[sample]]))))
}

#use aneufinder package to calculate PCA plot
p.PCA <- plot_pca(unlist(my_files), colorBy=classes, PC1=1, PC2=2)

#Add aesthetics to PCA plots using ggplot2
my_plot <- ggplot(p.PCA$data, aes(x=PC1, y=PC2, color = color, label = labels))

my_plot_jitter <- my_plot + 
  geom_point(position = position_jitter(width = 0.005, height = 0.005, seed = 1L)) +
  theme_bw()

my_plot_jitter_labels <- my_plot_jitter + 
    geom_text_repel(size = 1, position = position_jitter(width = 0.005, height = 0.005, seed = 1L))

#view plots
my_plot
my_plot_jitter
my_plot_jitter_labels


#save plots as .pdf to workdirectory
pdf("PCA plot_jitter.pdf", 
    width = 12, height = 8, 
    paper = "A4")
plot(my_plot_jitter)
dev.off()

pdf("PCA plot_jitter_labels.pdf", 
    width = 12, height = 8,
    paper = "A4")
plot(my_plot_jitter_labels)
dev.off()


#save plots as .png to workdirectory
png(filename = "PCA plot_jitter.png", 
    width = 800, height = 600, 
    unit = "px")
plot(my_plot_jitter)
dev.off()

png(filename ="PCA plot_jitter_labels.png", 
    width = 800, height = 800, 
    unit = "px")
plot(my_plot_jitter_labels)
dev.off()
  