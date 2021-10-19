# AneufinderDataFunctions
Small collection of basic scripts to read and combine Aneufinder data to generate new plots. Especially useful for non-expert R users. Scripts should be quite self-explanatory so I haven't included user instructions here.


## Included Scripts

- __Aneufinder PCA plotting__

*Generate a PCA plot in R containing the single cells from one or more samples. Each sample should be located within it's own folder. Folder name is used as sampleID.*
 
 - __Clustered color-coded Genomewide Heatmap__

*Easily combine data from multiple samples into a genomewide heatmap with color-coded labels for each sample.  
 
- __Reorganize Aneufinder plots__

*Some people don't like that the standard single cell karyotype and genomewide anuefinder plots are not ordered numerically from e.g. 1 to 100. This script is heplful to generate pdf plots in which the single cells are ordered according to file numbering from 1 to 384.*

- __Organize files from 384-well plate to sample folders__

*Script that redistributes .bed files from 384 well plate format based their numbering to separate sample folders.
