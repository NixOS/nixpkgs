. $stdenv/setup


buildPhase() {
    make include/linux/version.h
}

buildPhase=buildPhase


installPhase() {
    mkdir $out
    mkdir $out/include
    cp -prvd include/linux include/asm-i386 $out/include
    cd $out/include
    ln -s asm-i386 asm
    echo -n > $out/include/linux/autoconf.h
}

installPhase=installPhase


genericBuild
