#!/usr/bin/env Rscript
library(data.table)
library(parallel)
cl <- makeCluster(10)

biocVersion <- 3.11
snapshotDate <- Sys.Date()-1

mirrorUrls <- list( bioc=paste0("http://bioconductor.statistik.tu-dortmund.de/packages/", biocVersion, "/bioc/src/contrib/")
                  , "bioc-annotation"=paste0("http://bioconductor.statistik.tu-dortmund.de/packages/", biocVersion, "/data/annotation/src/contrib/")
                  , "bioc-experiment"=paste0("http://bioconductor.statistik.tu-dortmund.de/packages/", biocVersion, "/data/experiment/src/contrib/")
                  , cran=paste0("http://mran.revolutionanalytics.com/snapshot/", snapshotDate, "/src/contrib/")
                  )

args <- commandArgs(trailingOnly=TRUE)
mirrorType <- args[1]
stopifnot(mirrorType %in% c(names(mirrorUrls), "github"))
packagesFile <- paste(mirrorType, 'packages.nix', sep='-')
readFormatted <- as.data.table(read.table(skip=8, sep='"', text=head(readLines(packagesFile), -1)))

write(paste("downloading package lists"), stderr())
knownPackages <- lapply(mirrorUrls, function(url) as.data.table(available.packages(url, filters=c("R_version", "OS_type", "duplicates")), method="libcurl"))

if(mirrorType == "github"){

    githubPkgsAndRef <-
        lapply(strsplit(args[-1], "@"), function(splt){
            if(length(splt) > 2) stop("Syntax Error: Please specify github packages as user/repo@commit")
            if(length(splt) == 1)
                splt <- c(splt, "HEAD")
            splt
        })

    oldPkgs <- readFormatted$V8
    newPkgsRegexes <- paste0(sapply(githubPkgsAndRef, function(x) x[1]), "$")
    oldPkgsToUpdate <- Reduce(function(acc, r){ acc | grepl(r, oldPkgs) }
                            , newPkgsRegexes, init = FALSE)
    oldPkgs <- readFormatted[!oldPkgsToUpdate]

    clusterExport(cl, c("readFormatted", "knownPackages"))

    githubPackages <- parLapply(cl, githubPkgsAndRef, function(splt){
        rp <- splt[1]
        ref <- splt[2]
        write(ref, stderr())
        rpUrl <- paste0("https://raw.githubusercontent.com/", rp, "/", ref, "/DESCRIPTION")
        conn <- url(rpUrl)
        desc <- as.data.frame(read.dcf(conn))
        close(conn)
        repoUrl <- paste0("https://github.com/", rp)
        cmd <- paste0("nix-prefetch-git --rev ", ref
                    , " --url ", repoUrl
                    , " | jq -r '.[\"sha256\", \"rev\"]'")
        shaAndRev <- system(cmd, intern = TRUE)
        desc$sha256 <- shaAndRev[1]
        desc$rev <- shaAndRev[2]
        desc$repoUrl <- repoUrl
        desc
    })

    githubPackages <- as.data.table(rbindlist(githubPackages, fill = TRUE))

   knownPackages$github <- githubPackages
}

pkgs <- knownPackages[mirrorType][[1]]
setkey(pkgs, Package)
knownPackages <- rbindlist(knownPackages, fill = TRUE)$Package
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

formatPackage <- function(name, version, sha256, depends, imports, linkingTo
                        , repoUrl, rev) {
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
    nix <- paste0("  ", attr, " = derive2 { name=\"", name, "\"; version=\"", version, "\"; sha256=\"", sha256, "\"; depends=[", depends, "];")
    if(!is.na(repoUrl))
        nix <- paste0(nix, " url = \"", repoUrl, "\";")
    if(!is.na(rev))
        nix <- paste0(nix, " rev = \"", rev, "\";")
    nix <- paste0(nix, " };")
    nix
}

write(paste("updating", mirrorType, "packages"), stderr())

if(mirrorType != "github"){
    # Seems wasteful to redownload, maybe we should refactor above
    pkgs <- as.data.table(available.packages(mirrorUrl, filters=c("R_version", "OS_type", "duplicates"), method="libcurl"))

    clusterExport(cl, c("nixPrefetch","readFormatted", "mirrorUrl", "knownPackages", "pkgs"))

    pkgs <- pkgs[order(Package)]
    pkgs$sha256 <- parApply(cl, pkgs, 1, function(p){
        nixPrefetch(p["Package"], p["Version"])
    })
} else {
    pkgs <- githubPackages
    pkgs <- pkgs[order(Package)]
}

nix <- apply(pkgs, 1, function(p){
    formatPackage(p["Package"], p["Version"], p["sha256"]
                , p["Depends"], p["Imports"], p["suggests"]
                , p["repoUrl"], p["rev"])})
write("done", stderr())

cat("# This file is generated from generate-r-packages.R. DO NOT EDIT.\n")
cat("# Execute the following command to update the file.\n")
cat("#\n")
cat(paste("# Rscript generate-r-packages.R", mirrorType, ">new && mv new", packagesFile))
cat("\n\n")
cat("{ self, derive }:\n")
cat("let derive2 = derive ")
if (mirrorType %in% c("cran", "github")) { cat("{ snapshot = \"", paste(snapshotDate), "\"; }", sep="")
} else if (mirrorType == "irkernel") { cat("{}")
} else { cat("{ biocVersion = \"", biocVersion, "\"; }", sep="") }
cat(";\n")
cat("in with self; {\n")
if(mirrorType == "github" & exists("oldPkgs")){
    cat(apply(oldPkgs, 1, paste0, collapse = '"'), sep = "\n")
}
cat(paste(nix, collapse="\n"), "\n", sep="")
cat("}\n")

stopCluster(cl)
