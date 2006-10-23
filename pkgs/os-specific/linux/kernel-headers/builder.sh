source $stdenv/setup


buildPhase() {
    make include/linux/version.h
}

buildPhase=buildPhase


installPhase() {
    mkdir $out
    mkdir $out/include
    cp -prvd include/linux include/asm-generic $out/include
    if test $system = "i686-linux"; then
        platform=i386
    elif test $system = "x86_64-linux"; then
        platform=x86_64
    elif test $system = "powerpc-linux"; then
        platform=ppw
    fi
    cp -prvd include/asm-$platform $out/include
    ln -s asm-$platform $out/include/asm
    echo -n > $out/include/linux/autoconf.h
}

installPhase=installPhase


genericBuild
