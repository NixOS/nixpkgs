source $stdenv/setup


buildPhase() {
    make include/linux/version.h
}

buildPhase=buildPhase


installPhase() {
    mkdir $out
    mkdir $out/include
    #cd $out/include
    #ln -s asm-arm asm
    make include/asm ARCH=arm
    cp -prvd include/linux include/asm include/asm-arm include/asm-generic $out/include
    echo -n > $out/include/linux/autoconf.h
}

installPhase=installPhase


genericBuild
