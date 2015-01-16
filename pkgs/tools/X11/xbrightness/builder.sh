source $stdenv/setup

configurePhase() {
    xmkmf
}

buildPhase() {
    make $makeFlags
}

installPhase() {
    make install BINDIR=$out/bin
    make install.man MANPATH=$out/share/man
}

genericBuild
