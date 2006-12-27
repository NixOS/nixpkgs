source $stdenv/setup
installFlags="PREFIX=$out"

if test -n "$sharedLibrary"; then

    preBuild=preBuild
    preBuild() {
        make -f Makefile-libbz2_so
    }

    preInstall=preInstall
    preInstall() {
        ensureDir $out/lib
        mv libbz2.so* $out/lib
    }
    
fi

postInstall=postInstall
postInstall() {
    rm $out/bin/bunzip2* $out/bin/bzcat*
    ln -s bzip2 $out/bin/bunzip2
    ln -s bzip2 $out/bin/bzcat
}

genericBuild
