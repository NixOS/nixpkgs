library(data.table)
library(parallel)
cl <- makeCluster(10)
options(repos=structure(c(CRAN="http://cran.rstudio.com/")))

nixPrefetch <- function(name, version) {
    system(paste0("nix-prefetch-url --type sha256 http://cran.rstudio.com/src/contrib/", name, "_", version, ".tar.gz"), intern=TRUE)
    # system(paste0("nix-hash --flat --base32 --type sha256 /nix/store/*", name, "_", version, ".tar.gz", "| head -n 1"), intern=TRUE)
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

clusterExport(cl, c("nixPrefetch"))

pkgs <- as.data.table(available.packages(filters=c("R_version", "OS_type", "CRAN", "duplicates")))
pkgs <- subset(pkgs, Repository=="http://cran.rstudio.com/src/contrib")
pkgs <- pkgs[order(Package)]
pkgs$sha256 <- parApply(cl, pkgs, 1, function(p) nixPrefetch(p[1], p[2]))
knownPackages <- unique(pkgs$Package)

nix <- apply(pkgs, 1, function(p) formatPackage(p[1], p[2], p[18], p[4], p[5], p[6], knownPackages))

cat("# This file is generated from generate-cran-packages.R. DO NOT EDIT.\n")
cat("# Execute the following command to update the file.\n")
cat("#\n")
cat("# Rscript generate-cran-packages.R > cran-packages.nix\n")
cat("\n")
cat("{ self, derive }: with self; {\n")
cat(paste(nix, collapse="\n"), "\n")
cat("}\n")

stopCluster(cl)
