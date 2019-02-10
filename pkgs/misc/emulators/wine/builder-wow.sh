## build described at http://wiki.winehq.org/Wine64

source $stdenv/setup

unpackPhase
cd $TMP/$sourceRoot
patchPhase

configureScript=$TMP/$sourceRoot/configure
mkdir -p $TMP/wine-wow $TMP/wine64

cd $TMP/wine64
sourceRoot=`pwd`
configureFlags="--enable-win64"
configurePhase
buildPhase
# checkPhase

cd $TMP/wine-wow
sourceRoot=`pwd`
configureFlags="--with-wine64=../wine64"
configurePhase
buildPhase
# checkPhase

eval "$preInstall"
cd $TMP/wine-wow && make install
cd $TMP/wine64 && make install
eval "$postInstall"
fixupPhase
