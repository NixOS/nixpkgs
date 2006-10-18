source $stdenv/setup

makeFlags="prefix=$out"
installFlags="prefix=$out"

postInstall=postInstall
postInstall() {
    (cd $out && ln -s lib-* lib)
    (cd $out/lib && ln -s start.o crt1.o)
}

genericBuild
