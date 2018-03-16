mesonConfigurePhase() {
    runHook preConfigure

    if [ -z "$dontAddPrefix" ]; then
        mesonFlags="--prefix=$prefix $mesonFlags"
    fi

    # Build release by default.
    if [ -n "@isCross@" ]; then
      crossMesonFlags="--cross-file=@crossFile@/cross-file.conf"
    fi

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

mesonCheckPhase() {
    runHook preCheck

    meson test --print-errorlogs

    runHook postCheck
}

if [ -z "$dontUseMesonCheck" -a -z "$checkPhase" ]; then
    checkPhase=mesonCheckPhase
fi
