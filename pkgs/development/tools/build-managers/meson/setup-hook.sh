mesonConfigurePhase() {
    runHook preConfigure

    if [ -z "$dontAddPrefix" ]; then
        mesonFlags="--prefix=$prefix $mesonFlags"
    fi

    # Build release by default.
    if [ -n "@isCross@" ]; then
      crossMesonFlags="--cross-file=@crossFile@/cross-file.conf"
    fi

    # See multiple-outputs.sh and meson’s coredata.py
    mesonFlags="\
        --libdir=${!outputLib}/lib --libexecdir=${!outputLib}/libexec \
        --bindir=${!outputBin}/bin --sbindir=${!outputBin}/sbin \
        --includedir=${!outputInclude}/include \
        --mandir=${!outputMan}/share/man --infodir=${!outputInfo}/share/info \
        --localedir=${!outputLib}/share/locale \
        -Dauto_features=disabled \
        $mesonFlags"

    mesonFlags="${crossMesonFlags+$crossMesonFlags }--buildtype=${mesonBuildType:-release} $mesonFlags"

    echo "meson flags: $mesonFlags ${mesonFlagsArray[@]}"

    CC=@cc@/bin/cc CXX=@cc@/bin/c++ meson build $mesonFlags "${mesonFlagsArray[@]}"
    cd build

    if ! [[ -v enableParallelBuilding ]]; then
        enableParallelBuilding=1
        echo "meson: enabled parallel building"
    fi

    runHook postConfigure
}

if [ -z "$dontUseMesonConfigure" -a -z "$configurePhase" ]; then
    setOutputFlags=
    configurePhase=mesonConfigurePhase
fi
