#!/usr/bin/env Rscript

# This script can be used to generate the .json file for a given R package set
# that is part of the `rPackages` tree
#
# See R section of the nixpkgs manual for an example of how to use this script

library(data.table)
library(parallel)
library(BiocManager)
library(jsonlite)

# always order strings according to POSIX ordering
locale <- Sys.setlocale(locale = "C")

biocVersion <- BiocManager:::.version_map()
biocVersion <- biocVersion[biocVersion$R == getRversion()[, 1:2],c("Bioc", "BiocStatus")]
if ("release" %in% biocVersion$BiocStatus) {
  biocVersion <-  as.character(biocVersion[biocVersion$BiocStatus == "release", "Bioc"])
} else {
  biocVersion <-  max(as.character(biocVersion$Bioc))
}

mirrorUrls <- list( bioc=paste0("http://bioconductor.org/packages/", biocVersion, "/bioc/src/contrib/")
                  , "bioc-annotation"=paste0("http://bioconductor.org/packages/", biocVersion, "/data/annotation/src/contrib/")
                  , "bioc-experiment"=paste0("http://bioconductor.org/packages/", biocVersion, "/data/experiment/src/contrib/")
                  , cran="https://cran.r-project.org/src/contrib/"
                  )

mirrorType <- commandArgs(trailingOnly=TRUE)[1]
stopifnot(mirrorType %in% names(mirrorUrls))

packagesFile <- paste(mirrorType, 'packages.json', sep='-')
prevPkgs <- fromJSON(packagesFile)$packages

write(paste("downloading package lists"), stderr())
pkgTables <- lapply(mirrorUrls, function(url) as.data.table(available.packages(url, filters=c("R_version", "OS_type", "duplicates")), method="libcurl"))
knownPackageNames <- c(unique(do.call("rbind", pkgTables)$Package))

pkgTable <- pkgTables[mirrorType][[1]]
mirrorUrl <- mirrorUrls[mirrorType][[1]]

escapeName <- function(name) {
    gsub(".", "_", switch(name, "import" = "r_import", "assert" = "r_assert", name), fixed=TRUE)
}

nixPrefetch <- function(name, version) {
  prevPkg <- prevPkgs[[escapeName(name)]]
  if (!is.null(prevPkg) && prevPkg$version == version)
    prevPkg$sha256

  else {
    # avoid nix-prefetch-url because it often fails to fetch/hash large files
    url <- paste0(mirrorUrl, name, "_", version, ".tar.gz")
    tmp <- tempfile(pattern=paste0(name, "_", version), fileext=".tar.gz")
    cmd <- paste0("wget -q -O '", tmp, "' '", url, "'")
    if(mirrorType == "cran"){
      archiveUrl <- paste0(mirrorUrl, "Archive/", name, "/", name, "_", version, ".tar.gz")
      cmd <- paste0(cmd, " || wget -q -O '", tmp, "' '", archiveUrl, "'")
    }
    cmd <- paste0(cmd, " && nix-hash --type sha256 --base32 --flat '", tmp, "'")
    cmd <- paste0(cmd, " && echo >&2 '  added ", name, " v", version, "'")
    cmd <- paste0(cmd, " ; rm -rf '", tmp, "'")
    system(cmd, intern=TRUE)
  }

}

formatPackage <- function(name, version, sha256, depends, imports, linkingTo) {
    options(warn=5)
    depends <- paste( if (is.na(depends)) "" else gsub("[ \t\n]+", "", depends)
                    , if (is.na(imports)) "" else gsub("[ \t\n]+", "", imports)
                    , if (is.na(linkingTo)) "" else gsub("[ \t\n]+", "", linkingTo)
                    , sep=","
                    )
    depends <- unlist(strsplit(depends, split=",", fixed=TRUE))
    depends <- lapply(depends, gsub, pattern="([^ \t\n(]+).*", replacement="\\1")
    depends <- depends[depends %in% knownPackageNames]
    depends <- lapply(depends, escapeName)
    depends <- paste(depends)
    depends <- sort(unique(depends))
    list(name=unbox(name), version=unbox(version), sha256=unbox(sha256), depends=depends)
}

cl <- makeCluster(10)
clusterExport(cl, c("escapeName", "nixPrefetch", "prevPkgs", "mirrorUrl", "mirrorType", "knownPackageNames"))

write(paste("updating", mirrorType, "packages"), stderr())
pkgTable$sha256 <- parApply(cl, pkgTable, 1, function(p) nixPrefetch(p[1], p[2]))

stopCluster(cl)

pkgs <- lapply(1:nrow(pkgTable), function(i) with(pkgTable[i,], formatPackage(Package, Version, sha256, Depends, Imports, LinkingTo)))
names(pkgs) <- lapply(pkgs, function(p) escapeName(p$name))

# Mark deleted packages as broken
brokenPkgs <- lapply(prevPkgs[setdiff(names(prevPkgs), names(pkgs))], function(p)
  list(name=unbox(p$name),
       version=unbox(p$version),
       sha256=unbox(p$sha256),
       depends=p$depends,
       broken=unbox(T)))

# sort packages by their non-escaped names
pkgs <- pkgs[order(sapply(pkgs, function(p) p$name))]
brokenPkgs<- brokenPkgs[order(sapply(brokenPkgs, function(p) p$name))]

# empty named list
extraArgs = setNames(list(), character(0))

if (mirrorType != "cran") {
  extraArgs=list(biocVersion=unbox(paste(biocVersion)))
}

cat(toJSON(list(extraArgs=extraArgs, packages=c(pkgs, brokenPkgs)), pretty=TRUE))
cat("\n")
write("done", stderr())
