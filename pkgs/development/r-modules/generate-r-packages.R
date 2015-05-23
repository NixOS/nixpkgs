#!/usr/bin/env Rscript

library(data.table)
library(parallel)
cl <- makeCluster(10)

mirrorType <- commandArgs(trailingOnly=TRUE)[1]
packagesFile <- paste(mirrorType, 'packages.nix', sep='-')
mirrorUrls <- list(
  bioc="http://bioconductor.statistik.tu-dortmund.de/packages/3.0/bioc",
  cran="http://cran.r-project.org"
)
mirrorUrl <- paste(mirrorUrls[mirrorType], "/src/contrib/", sep="")

readFormatted <- as.data.table(read.table(skip=6, sep='"', text=head(readLines(packagesFile), -1)))

nixPrefetch <- function(name, version) {
  prevV <- readFormatted$V2 == name & readFormatted$V4 == version
  if (sum(prevV) == 1) as.character(readFormatted$V6[ prevV ]) else
    system(paste0("nix-prefetch-url --type sha256 ", mirrorUrl, name, "_", version, ".tar.gz"), intern=TRUE)
}

formatPackage <- function(name, version, sha256, depends, imports, linkingTo, knownPackages) {
    attr <- gsub(".", "_", name, fixed=TRUE)
    if (is.na(depends)) depends <- "";
    depends <- unlist(strsplit(depends, split="[ \t\n]*,[ \t\n]*", fixed=FALSE))
    depends <- c(depends, unlist(strsplit(imports, split="[ \t\n]*,[ \t\n]*", fixed=FALSE)))
    depends <- c(depends, unlist(strsplit(linkingTo, split="[ \t\n]*,[ \t\n]*", fixed=FALSE)))
    depends <- sapply(depends, gsub, pattern="([^ \t\n(]+).*", replacement="\\1")
    depends <- depends[depends %in% knownPackages]
    depends <- sapply(depends, gsub, pattern=".", replacement="_", fixed=TRUE)
    depends <- paste(depends, collapse=" ")
    paste0(attr, " = derive { name=\"", name, "\"; version=\"", version, "\"; sha256=\"", sha256, "\"; depends=[", depends, "]; };")
}

clusterExport(cl, c("nixPrefetch","readFormatted", "mirrorUrl"))

pkgs <- as.data.table(available.packages(mirrorUrl, filters=c("R_version", "OS_type", "duplicates")))
pkgs <- pkgs[order(Package)]
pkgs$sha256 <- parApply(cl, pkgs, 1, function(p) nixPrefetch(p[1], p[2]))
knownPackages <- unique(pkgs$Package)

nix <- apply(pkgs, 1, function(p) formatPackage(p[1], p[2], p[18], p[4], p[5], p[6], knownPackages))

cat("# This file is generated from generate-r-packages.R. DO NOT EDIT.\n")
cat("# Execute the following command to update the file.\n")
cat("#\n")
cat(paste("# Rscript generate-r-packages.R", mirrorType, ">", packagesFile))
cat("\n\n")
cat("{ self, derive }: with self; {\n")
cat(paste(nix, collapse="\n"), "\n")
cat("}\n")

stopCluster(cl)
