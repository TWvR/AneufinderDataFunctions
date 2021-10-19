###---------- Generate Ordered Aneufinder plots ------###

#----Thomas van Ravesteyn, t.ravesteyn@hubrecht.eu
#----Kops Group
#----Hubrecht Institute

#Input: Aneufinder model files
#Output: Ordered Aneufinder Genomewide and/or single cell plots


###--------------- Load dependencies -----------------###
###---------------------------------------------------###

library(AneuFinder)


###--------------Settings before start----------------###
###---------------------------------------------------###

#Set  working directory, should be the folder that contains the model files
setwd("C:/Users/t.ravesteyn/OneDrive - Hubrecht Institute/R workspace/Aneufinder/Input/run33_embryo4 output/embryoplate6/MODELS/method-edivisive")

#collect files
my_files <- list.files()

#create ordered vector with numbers
my_cell_numbers <- paste0("cell_", 1:384, ".bed")

#order files according to my_cell_numbers vector
my_ordered_files <- c()
for (i in my_cell_numbers){
  my_ordered_files <- append(my_ordered_files, my_files[[grep(i, my_files)]])
}

###------- Create re-ordered genomewide heatmap --------###
###-----------------------------------------------------###

#create ordered genomewide heatmap with all cells, save to workdirectory
heatmapGenomewide(rev(my_ordered_files), 
                  classes = NULL, classes.color = NULL, 
                  reorder.by.class = F,  cluster = F,
                  file = c("my_genomewide_cluster_plot.pdf"))

###------- Create re-ordered singles pdf ---------------###
###-----------------------------------------------------###

#create ordered pdf with single cell profiles, save to workdirectory
pdf(file = "my_single-cells_plot.pdf", width = 50/2.54, height = 15/2.54)
for(i in 1:length(my_ordered_files)) {
    print(plot(my_ordered_files[i], type = 1))
    message("Plotted cell ", i, "/", length(my_ordered_files))
}
dev.off()



