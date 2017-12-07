mesonConfigurePhase() {
    runHook preConfigure

    if [ -z "$dontAddPrefix" ]; then
        mesonFlags="--prefix=$prefix $mesonFlags"
    fi

    # Build release by default.
    mesonFlags="--buildtype=${mesonBuildType:-release} $mesonFlags"

    echo "meson flags: $mesonFlags ${mesonFlagsArray[@]}"

    meson build $mesonFlags "${mesonFlagsArray[@]}"
    cd build

    runHook postConfigure
}

if [ -z "$dontUseMesonConfigure" -a -z "$configurePhase" ]; then
    setOutputFlags=
    configurePhase=mesonConfigurePhase
fi
