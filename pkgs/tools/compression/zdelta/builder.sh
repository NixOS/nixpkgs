source $stdenv/setup

installPhase() {
    ensureDir $out/bin
    cp -p zdc zdu $out/bin
}

genericBuild
