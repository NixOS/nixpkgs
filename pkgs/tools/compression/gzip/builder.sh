source $stdenv/setup

postInstall=postInstall
postInstall() {
    ln -sf gzip $out/bin/gunzip
    ln -sf gzip $out/bin/zcat
}

genericBuild
