source $stdenv/setup


buildPhase() {
    make include/linux/version.h
}

buildPhase=buildPhase


installPhase() {
    mkdir $out
    mkdir $out/include
    if test $system = "i686-linux"; then
        cp -prvd include/linux include/asm-i386 include/asm-generic $out/include
        cd $out/include
        ln -s asm-i386 asm
    elif test $system = "powerpc-linux"; then
        cp -prvd include/linux include/asm-ppc include/asm-generic $out/include
        cd $out/include
        ln -s asm-ppc asm
    fi
    echo -n > $out/include/linux/autoconf.h
}

installPhase=installPhase


genericBuild
