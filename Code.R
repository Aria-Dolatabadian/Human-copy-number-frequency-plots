#https://genviz.org/module-03-genvisr/0003/05/01/cnFreq_GenVisR/

library("stringr")
library("GenVisR")

# get locations of all cn files
files <- Sys.glob("*.cc2.tsv") #reads all tsv files in WD

# create function to read in and format data
a <- function(x){
    # read data and set column names
    data <- read.delim(x, header=FALSE)
    colnames(data) <- c("chromosome", "start", "end", "probes", "segmean")

    # get the sample name from the file path
    sampleName <- str_extract(x, "H_OM.+cc2")
    sampleName <- gsub(".cc2", "", sampleName)
    data$sample <- sampleName

    # return the data
    return(data)
}

# run the anonymous function defined above
cnData <- lapply(files, a)

# turn the list of data frames into a single data frame
cnData <- do.call("rbind", cnData)

# call the cnFreq function
cnFreq(cnData, genome="hg19")

# change the CN cutoffs
cnFreq(cnData, genome="hg19", CN_low_cutoff = 0, CN_high_cutoff = .1)

# highlight ERBB2
library(ggplot2)
layer1 <- geom_vline(xintercept=c(39709170))
cnFreq(cnData, genome="hg19", plotChr="chr17", plotLayer=layer1)


