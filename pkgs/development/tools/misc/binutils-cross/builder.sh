source $stdenv/setup

patchConfigure() {
    # Clear the default library search path.
    if test "$noSysDirs" = "1"; then
        echo 'NATIVE_LIB_DIRS=' >> ld/configure.tgt
    fi
}

preConfigure=patchConfigure

genericBuild
