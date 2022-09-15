# AneufinderDataFunctions
Small collection of basic scripts to read and combine Aneufinder data to generate new plots. Especially useful for non-expert R users. These scripts should be quite self-explanatory, but if you have any questions, please don't hestitate to send me an email.


## Included Scripts

- __Aneufinder PCA plotting__

*Generate a PCA plot in R containing the single cells from one or more samples. Each sample should be located within it's own folder. Folder name is used as sampleID. Uses Aneufinder functions.*
 

- __Clustered color-coded Genomewide Heatmap__

*Easily combine data from multiple samples into a genomewide heatmap with color-coded labels for each sample. Uses Aneufinder functions.* 
 
 
- __Karyotype Measurements__

*Easily obtain Aneuploidy and Heterogeneity karyotype measurements from a collection of samples, each containing multiple single cells. Uses Aneufinder functions.* 


- __Subset 384 .bed files to sample folders__

*Script that subsets .bed files from 384 well plate format based on their numbering to separate sample folders. This script is based on 4 equally divided subsets. sample 1 columns 1-6, subset B in columns 7-12, etc. First and last well from each sample is taken seperately to control sample folder. Script can be easily adjusted to different number of samples and/or wells.*


- __Reorganize Aneufinder plots__

*Some people don't like that the standard single cell karyotype and genomewide aneufinder plots are not ordered numerically from e.g. 1 to 100. This script is heplful to generate pdf plots in which the single cells are ordered according to file numbering from 1 to 384. Uses Aneufinder functions.*
