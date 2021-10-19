###------- Subset samples based on 384 well-number  ---------###

#----Thomas van Ravesteyn, t.ravesteyn@hubrecht.eu
#----Kops Group
#----Hubrecht Institute

#input: numbered .bed files
#output: 4 folders containing a subset of the .bed files. 

#sorting is based on 4 samples, each with 6 neighboring columns in 384 plate
#first and last single well per sample will be subset to seperate controls directory


###--------------- Settings before start -------------###
###---------------------------------------------------###


#set input directory that contains the files that need to be sorted
input_dir <- ("/Input/TRscFACS_10A")

#set plate name (will be included in sample folder names, optional)
name.plate <- c("TRscFACS_8A")

#set sample names (e.g. c(paste0("your name", name.plate)) - to included plate name)
name.sample1 <- c(paste0("C009_",name.plate , "_p20"))
name.sample2 <- c(paste0("C033_",name.plate , "_p22"))
name.sample3 <- c(paste0("P11N-APKS-empty_",name.plate , "_punk+19"))
name.sample4 <- c(paste0("C007_",name.plate , "_p4"))

#rename files if .bed extension is missing (TRUE/FALSE)
rename.my.files <- TRUE


###--------------- Collect data, make new dirs and subset .bed files -------------###
###--------------------------------------------------------------------------###

#retrieve files present in WD, these are the files that will be sorted
my.files <- list.files(path = input_dir, full.names = T)

#add .bed extension if this is lacking.
if (rename.my.files == TRUE){
  file.rename(my.files, paste0(my.files, ".bed"))
  my.files <- list.files(path = input_dir, full.names = T)
}
  
#combine sample names to single vector
sample.names <- c(name.sample1, name.sample2, name.sample3, name.sample4, "controls")


#Assign barcode numbers to each sample
barcodes.sample1  <- c(2:6, 26:30, 49:54, 73:78, 97:102, 121:126, 145:150,
                      169:174, 193:198, 217:222, 241:246, 265:270,
                      289:294, 313:318, 337:342, 361:365)
barcodes.sample2 <- c(8:12, 32:36, 55:60, 79:84, 103:108, 127:132, 151:156,
                      175:180, 199:204, 223:228, 247:252, 271:276, 295:300,
                      319:324, 343:348, 367:371)
barcodes.sample3 <- c(14:18, 38:42, 61:66, 85:90, 109:114, 133:138, 157:162,
                      181:186, 205:210, 229:234, 253:258, 277:282, 301:306,
                      325:330, 349:354, 373:377)
barcodes.sample4 <- c(20:24, 44:48, 67:72, 91:96, 115:120, 139:144, 163:168,
                      187:192, 211:216, 235:240, 259:264, 283:288, 307:312,
                      331:336, 355:360, 379:383)

barcodes.neg.control <- c(1, 7, 13, 19, 25, 31, 37, 43)
barcodes.pos.control <- c(366, 372, 378, 384)
barcodes.controls <- c(barcodes.neg.control, barcodes.pos.control)


my.barcodes <- list(barcodes.sample1, barcodes.sample2, barcodes.sample3, barcodes.sample4, barcodes.controls)

#create files names that correspond to sample barcodes
files.sample1 <- paste0(input_dir, barcodes.sample1, ".bed")
files.sample2 <- paste0(input_dir,barcodes.sample2, ".bed")
files.sample3 <- paste0(input_dir,barcodes.sample3, ".bed")
files.sample4 <- paste0(input_dir,barcodes.sample4, ".bed")
files.controls <- paste0(input_dir,barcodes.controls, ".bed")

barcoded.files <- list(files.sample1, files.sample2, files.sample3, files.sample4, files.controls)


# create list that contains file names and barcodes, ordered per sample
my.384.plate <- list()
for (i in 1:length(sample.names)){
  my.dir <- paste0(sample.names[i], "/") 
  dir.create(sample.names[i])
  my.list <- list(sample.names[i], my.dir, my.barcodes[[i]], barcoded.files[[i]])
  names(my.list) <- c("name", "dir","barcodes", "files")
  my.384.plate[[sample.names[i]]] <- my.list
}

#sort files to new directories according to their barcode 
for (ID in sample.names){
  for (i in 1:length(my.files)){
    if  (my.files[i] %in% my.384.plate[[ID]]$files){
      file.copy(my.files[i], my.384.plate[[ID]]$dir)
    }
  }
}