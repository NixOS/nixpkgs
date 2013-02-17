source $stdenv/setup
installFlags="PREFIX=$out"

if test -n "$sharedLibrary"; then

    preBuild() {
        make -f Makefile-libbz2_so
    }

    preInstall() {
        mkdir -p $out/lib
        mv libbz2.so* $out/lib
        (cd $out/lib && ln -s libbz2.so.1.0.? libbz2.so && ln -s libbz2.so.1.0.? libbz2.so.1);
    }
    
fi

postInstall() {
    rm $out/bin/bunzip2* $out/bin/bzcat*
    ln -s bzip2 $out/bin/bunzip2
    ln -s bzip2 $out/bin/bzcat
}

genericBuild
