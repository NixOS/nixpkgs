#!/usr/bin/env Rscript
library(data.table)
library(parallel)
cl <- makeCluster(10)

mirrorType <- commandArgs(trailingOnly=TRUE)[1]
stopifnot(mirrorType %in% c("bioc","cran", "irkernel"))

packagesFile <- paste(mirrorType, 'packages.nix', sep='-')
readFormatted <- as.data.table(read.table(skip=8, sep='"', text=head(readLines(packagesFile), -1)))
rVersion <- paste(R.Version()$major, strsplit(R.Version()$minor, ".", fixed=TRUE)[[1]][1], sep=".")
snapshotDate <- Sys.Date()

mirrorUrls <- list( bioc=paste0("https://bioconductor.statistik.tu-dortmund.de/packages/", rVersion, "/bioc/src/contrib/")
                  , cran=paste0("https://mran.revolutionanalytics.com/snapshot/", snapshotDate, "/src/contrib/")
                  , irkernel="https://irkernel.github.io/src/contrib/"
                  )
mirrorUrl <- mirrorUrls[mirrorType][[1]]
knownPackages <- lapply(mirrorUrls, function(url) as.data.table(available.packages(url, filters=c("R_version", "OS_type", "duplicates")), method="libcurl"))
pkgs <- knownPackages[mirrorType][[1]]
setkey(pkgs, Package)
knownPackages <- c(unique(do.call("rbind", knownPackages)$Package))
knownPackages <- sapply(knownPackages, gsub, pattern=".", replacement="_", fixed=TRUE)

nixPrefetch <- function(name, version) {
  prevV <- readFormatted$V2 == name & readFormatted$V4 == version
  if (sum(prevV) == 1) as.character(readFormatted$V6[ prevV ]) else
    system(paste0("nix-prefetch-url --type sha256 ", mirrorUrl, name, "_", version, ".tar.gz"), intern=TRUE)
}

formatPackage <- function(name, version, sha256, depends, imports, linkingTo) {
    attr <- gsub(".", "_", name, fixed=TRUE)
    depends <- paste( if (is.na(depends)) "" else gsub("[ \t\n]+", "", depends)
                    , if (is.na(imports)) "" else gsub("[ \t\n]+", "", imports)
                    , if (is.na(linkingTo)) "" else gsub("[ \t\n]+", "", linkingTo)
                    , sep=","
                    )
    depends <- unlist(strsplit(depends, split=",", fixed=TRUE))
    depends <- sapply(depends, gsub, pattern="([^ \t\n(]+).*", replacement="\\1")
    depends <- sapply(depends, gsub, pattern=".", replacement="_", fixed=TRUE)
    depends <- depends[depends %in% knownPackages]
    depends <- paste(sort(unique(depends)), collapse=" ")
    paste0("  ", attr, " = derive2 { name=\"", name, "\"; version=\"", version, "\"; sha256=\"", sha256, "\"; depends=[", depends, "]; };")
}

clusterExport(cl, c("nixPrefetch","readFormatted", "mirrorUrl", "knownPackages"))

pkgs <- as.data.table(available.packages(mirrorUrl, filters=c("R_version", "OS_type", "duplicates"), method="libcurl"))
pkgs <- pkgs[order(Package)]
pkgs$sha256 <- parApply(cl, pkgs, 1, function(p) nixPrefetch(p[1], p[2]))

nix <- apply(pkgs, 1, function(p) formatPackage(p[1], p[2], p[18], p[4], p[5], p[6]))

cat("# This file is generated from generate-r-packages.R. DO NOT EDIT.\n")
cat("# Execute the following command to update the file.\n")
cat("#\n")
cat(paste("# Rscript generate-r-packages.R", mirrorType, ">new && mv new", packagesFile))
cat("\n\n")
cat("{ self, derive }:\n")
cat("let derive2 = derive ")
if (mirrorType == "bioc") { cat("{ rVersion = \"", rVersion, "\"; }", sep="")
} else if (mirrorType == "cran") { cat("{ snapshot = \"", paste(snapshotDate), "\"; }", sep="")
} else if (mirrorType == "irkernel") { cat("{}") }
cat(";\n")
cat("in with self; {\n")
cat(paste(nix, collapse="\n"), "\n", sep="")
cat("}\n")

stopCluster(cl)
