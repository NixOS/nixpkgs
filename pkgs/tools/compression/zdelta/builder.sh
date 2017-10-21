source $stdenv/setup

installPhase() {
    mkdir -p $out/bin
    cp -p zdc zdu $out/bin
}

genericBuild
