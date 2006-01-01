source $stdenv/setup

if test $cross = "arm-linux" ; then
  configureFlags="--target=arm-linux"
elif test $cross = "mips-linux" ; then
  configureFlags="--target=mips-linux"
elif test $cross = "sparc-linux" ; then
  configureFlags="--target=sparc-linux"
elif test $cross = "powerpc-linux" ; then
  configureFlags="--target=powerpc-linux"
elif test $cross = "ppc-linux" ; then
  configureFlags="--target=powerpc-linux"
fi

patchConfigure() {
    # Clear the default library search path.
    if test "$noSysDirs" = "1"; then
        echo 'NATIVE_LIB_DIRS=' >> ld/configure.tgt
    fi
}

preConfigure=patchConfigure

genericBuild
