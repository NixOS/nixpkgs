source $stdenv/setup

buildPhase=buildPhase
buildPhase() {
    xmkmf
    make World
}

installPhase=installPhase
installPhase() {
    ensureDir $out/bin
    ensureDir $out/man/man1
    ./vncinstall $out/bin $out/man
}

genericBuild
