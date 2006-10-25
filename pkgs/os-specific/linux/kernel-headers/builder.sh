source $stdenv/setup


buildPhase() {
    make include/linux/version.h
}

buildPhase=buildPhase


installPhase() {
    mkdir $out
    mkdir $out/include
    cp -prvd include/linux include/asm-generic $out/include
    cp -prvd include/asm-$platform $out/include
    ln -s asm-$platform $out/include/asm
    echo -n > $out/include/linux/autoconf.h
}

installPhase=installPhase


genericBuild
