source $stdenv/setup
installFlags="PREFIX=$out"

preBuild() {
    cp Makefile.def Makefile
}

postInstall() {
    rm $out/bin/uncompress* $out/bin/zcat*
    ln -s compress $out/bin/uncompress
    ln -s compress $out/bin/zcat
}

genericBuild
