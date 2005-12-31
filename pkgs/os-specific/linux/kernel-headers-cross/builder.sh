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
    if test $cross = "arm-linux"; then
       arch=arm
    else if test $cross = "mips-linux"; then
           arch=mips
         fi
    fi
    make include/asm ARCH=$arch
    cp -prvd include/linux include/asm include/asm-$arch include/asm-generic $out/include
    echo -n > $out/include/linux/autoconf.h
}

installPhase=installPhase


genericBuild
