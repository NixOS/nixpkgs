######################################################################
# configure and build phases

configurePhase() {
    runHook preConfigure

    if [ -z "$configureScript" ]; then
        configureScript=./configure
        if ! [ -x $configureScript ]; then
            echo "no configure script, doing nothing"
            return
        fi
    fi

    if [ -z "$dontFixLibtool" ]; then
        find . -iname "ltmain.sh" | while read i; do
            echo "fixing libtool script $i"
            _fixLibtool $i
        done
    fi

    if [ -z "$dontAddPrefix" -a -n "$prefix" ]; then
        configureFlags="${prefixKey:---prefix=}$prefix $configureFlags"
    fi

    # Add --disable-dependency-tracking to speed up some builds.
    if [ -z "$dontAddDisableDepTrack" ]; then
        if grep -q dependency-tracking $configureScript; then
            configureFlags="--disable-dependency-tracking $configureFlags"
        fi
    fi

    # By default, disable static builds.
    if [ -z "$dontDisableStatic" ]; then
        if grep -q enable-static $configureScript; then
            configureFlags="--disable-static $configureFlags"
        fi
    fi

    echo "configure flags: $configureFlags ${configureFlagsArray[@]}"
    $configureScript $configureFlags "${configureFlagsArray[@]}"

    runHook postConfigure
}

_fixLibtool() {
    sed -i -e 's^eval sys_lib_.*search_path=.*^^' "$1"
}

buildPhase() {
    runHook preBuild

    if [ -z "$makeFlags" ] && ! [ -n "$makefile" -o -e "Makefile" -o -e "makefile" -o -e "GNUmakefile" ]; then
        echo "no Makefile, doing nothing"
        return
    fi

    # See https://github.com/NixOS/nixpkgs/pull/1354#issuecomment-31260409
    makeFlags="SHELL=$SHELL $makeFlags"

    echo "make flags: $makeFlags ${makeFlagsArray[@]} $buildFlags ${buildFlagsArray[@]}"
    make ${makefile:+-f $makefile} \
        ${enableParallelBuilding:+-j${NIX_BUILD_CORES} -l${NIX_BUILD_CORES}} \
        $makeFlags "${makeFlagsArray[@]}" \
        $buildFlags "${buildFlagsArray[@]}"

    runHook postBuild
}

