source $stdenv/setup

configureFlags=" --disable-nls --disable-shared --enable-static"
makeFlags="LDFLAGS=-all-static"

patchConfigure() {
    # Clear the default library search path.
    if test "$noSysDirs" = "1"; then
        echo 'NATIVE_LIB_DIRS=' >> ld/configure.tgt
    fi
}

preConfigure=patchConfigure

preBuild() {
    make configure-host
}

preBuild=preBuild

genericBuild
