#!/usr/bin/env Rscript
library(data.table)
library(parallel)
cl <- makeCluster(10)

rVersion <- paste(R.Version()$major, strsplit(R.Version()$minor, ".", fixed=TRUE)[[1]][1], sep=".")
snapshotDate <- Sys.Date()-1

mirrorUrls <- list( bioc=paste0("http://bioconductor.statistik.tu-dortmund.de/packages/", rVersion, "/bioc/src/contrib/")
                  , "bioc-annotation"=paste0("http://bioconductor.statistik.tu-dortmund.de/packages/", rVersion, "/data/annotation/src/contrib/")
                  , "bioc-experiment"=paste0("http://bioconductor.statistik.tu-dortmund.de/packages/", rVersion, "/data/experiment/src/contrib/")
                  , cran=paste0("http://mran.revolutionanalytics.com/snapshot/", snapshotDate, "/src/contrib/")
                  , irkernel="http://irkernel.github.io/src/contrib/"
                  )

mirrorType <- commandArgs(trailingOnly=TRUE)[1]
stopifnot(mirrorType %in% names(mirrorUrls))
packagesFile <- paste(mirrorType, 'packages.nix', sep='-')
readFormatted <- as.data.table(read.table(skip=8, sep='"', text=head(readLines(packagesFile), -1)))

write(paste("downloading package lists"), stderr())
knownPackages <- lapply(mirrorUrls, function(url) as.data.table(available.packages(url, filters=c("R_version", "OS_type", "duplicates")), method="libcurl"))
pkgs <- knownPackages[mirrorType][[1]]
setkey(pkgs, Package)
knownPackages <- c(unique(do.call("rbind", knownPackages)$Package))
knownPackages <- sapply(knownPackages, gsub, pattern=".", replacement="_", fixed=TRUE)

mirrorUrl <- mirrorUrls[mirrorType][[1]]
nixPrefetch <- function(name, version) {
  prevV <- readFormatted$V2 == name & readFormatted$V4 == version
  if (sum(prevV) == 1)
    as.character(readFormatted$V6[ prevV ])

  else {
    # avoid nix-prefetch-url because it often fails to fetch/hash large files
    url <- paste0(mirrorUrl, name, "_", version, ".tar.gz")
    tmp <- tempfile(pattern=paste0(name, "_", version), fileext=".tar.gz")
    cmd <- paste0("wget -q -O '", tmp, "' '", url, "'")
    cmd <- paste0(cmd, " && nix-hash --type sha256 --base32 --flat '", tmp, "'")
    cmd <- paste0(cmd, " && echo >&2 '  added ", name, " v", version, "'")
    cmd <- paste0(cmd, " ; rm -rf '", tmp, "'")
    system(cmd, intern=TRUE)
  }

}

formatPackage <- function(name, version, sha256, depends, imports, linkingTo) {
    name <- ifelse(name == "import", "r_import", name)
    attr <- gsub(".", "_", name, fixed=TRUE)
    options(warn=5)
    depends <- paste( if (is.na(depends)) "" else gsub("[ \t\n]+", "", depends)
                    , if (is.na(imports)) "" else gsub("[ \t\n]+", "", imports)
                    , if (is.na(linkingTo)) "" else gsub("[ \t\n]+", "", linkingTo)
                    , sep=","
                    )
    depends <- unlist(strsplit(depends, split=",", fixed=TRUE))
    depends <- lapply(depends, gsub, pattern="([^ \t\n(]+).*", replacement="\\1")
    depends <- lapply(depends, gsub, pattern=".", replacement="_", fixed=TRUE)
    depends <- depends[depends %in% knownPackages]
    depends <- lapply(depends, function(d) ifelse(d == "import", "r_import", d))
    depends <- paste(depends)
    depends <- paste(sort(unique(depends)), collapse=" ")
    paste0("  ", attr, " = derive2 { name=\"", name, "\"; version=\"", version, "\"; sha256=\"", sha256, "\"; depends=[", depends, "]; };")
}

clusterExport(cl, c("nixPrefetch","readFormatted", "mirrorUrl", "knownPackages"))

pkgs <- as.data.table(available.packages(mirrorUrl, filters=c("R_version", "OS_type", "duplicates"), method="libcurl"))
pkgs <- pkgs[order(Package)]

write(paste("updating", mirrorType, "packages"), stderr())
pkgs$sha256 <- parApply(cl, pkgs, 1, function(p) nixPrefetch(p[1], p[2]))
nix <- apply(pkgs, 1, function(p) formatPackage(p[1], p[2], p[18], p[4], p[5], p[6]))
write("done", stderr())

cat("# This file is generated from generate-r-packages.R. DO NOT EDIT.\n")
cat("# Execute the following command to update the file.\n")
cat("#\n")
cat(paste("# Rscript generate-r-packages.R", mirrorType, ">new && mv new", packagesFile))
cat("\n\n")
cat("{ self, derive }:\n")
cat("let derive2 = derive ")
if (mirrorType == "cran") { cat("{ snapshot = \"", paste(snapshotDate), "\"; }", sep="")
} else if (mirrorType == "irkernel") { cat("{}")
} else { cat("{ rVersion = \"", rVersion, "\"; }", sep="") }
cat(";\n")
cat("in with self; {\n")
cat(paste(nix, collapse="\n"), "\n", sep="")
cat("}\n")

stopCluster(cl)
