source $stdenv/setup


buildPhase() {
    make include/linux/version.h
}


installPhase() {
    mkdir $out
    mkdir $out/include
    #cd $out/include
    #ln -s asm-arm asm
    if test $cross = "arm-linux"; then
       arch=arm
    elif test $cross = "mips-linux"; then
           arch=mips
    elif test $cross = "sparc-linux"; then
           arch=sparc
    elif test $cross = "powerpc-linux"; then
           arch=ppc
    elif test $cross = "ppc-linux"; then
           arch=ppc
    fi
    make include/asm ARCH=$arch
    cp -prvd include/linux include/asm include/asm-$arch include/asm-generic $out/include
    echo -n > $out/include/linux/autoconf.h
}


genericBuild
