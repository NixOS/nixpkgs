source $stdenv/setup
installFlags="PREFIX=$out"

preBuild=preBuild
preBuild() {
    make -f Makefile-libbz2_so
}

preInstall=preInstall
preInstall() {
    ensureDir $out/lib
    cp -p libbz2.so* $out/lib
    ln -s libbz2.so.*.*.* $out/lib/libbz2.so
}

postInstall=postInstall
postInstall() {
    rm $out/bin/bunzip2 $out/bin/bzcat
    ln -s bzip2 $out/bin/bunzip2
    ln -s bzip2 $out/bin/bzcat
}

genericBuild

