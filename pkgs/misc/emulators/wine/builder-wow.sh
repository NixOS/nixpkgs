#!/bin/sh

source $stdenv/setup

unpackPhase
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
cd $TMP/wine64 && make install
cd $TMP/wine-wow && make install
eval "$postInstall"
fixupPhase
