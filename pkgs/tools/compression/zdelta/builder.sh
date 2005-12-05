source $stdenv/setup

installPhase=installPhase
installPhase() {
    ensureDir $out/bin
    cp -p zdc zdu $out/bin
}

genericBuild
