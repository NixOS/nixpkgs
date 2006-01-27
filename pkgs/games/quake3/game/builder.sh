source $stdenv/setup

dontMakeInstall=1
preInstall=preInstall
preInstall() {
    ensureDir $out/baseq3
    make copyfiles COPYDIR=$out
}

genericBuild
