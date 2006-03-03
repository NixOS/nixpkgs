source $stdenv/setup

buildPhase=buildPhase
buildPhase() {
    glibc=$(cat $NIX_GCC/nix-support/orig-glibc)
    for i in bin/*; do
        patchelf \
            --set-interpreter $glibc/lib/ld-linux.so.* \
            --set-rpath $libX11/lib:$libXext/lib \
            $i
    done
}

installPhase=installPhase
installPhase() {
    ensureDir $out
    cp -prvd * $out/
}

genericBuild