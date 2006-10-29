source $stdenv/setup

# !!! hack
source $NIX_GCC/nix-support/add-flags.sh
export NIX_LDFLAGS

postUnpack() {
    unp() {
        bunzip2 < $umlPatch > patch
    }
    unpackCmd=unp
    unpackFile $umlPatch
    patches="`pwd`/patch $noAioPatch"
}
postUnpack=postUnpack

configurePhase() {
    cp $config .config
    yes | make oldconfig ARCH=um
}
configurePhase=configurePhase

buildPhase() {
    make linux ARCH=um
    strip linux
    make modules ARCH=um
}
buildPhase=buildPhase

installPhase() {
    mkdir $out
    mkdir $out/bin
    cp -p linux $out/bin
    make modules_install INSTALL_MOD_PATH=$out ARCH=um
}
installPhase=installPhase

genericBuild
