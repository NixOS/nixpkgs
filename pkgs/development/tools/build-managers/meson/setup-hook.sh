mesonConfigurePhase() {
    runHook preConfigure

    if [ -z "${dontAddPrefix-}" ]; then
        mesonFlags="--prefix=$prefix $mesonFlags"
    fi

    # See multiple-outputs.sh and meson’s coredata.py
    mesonFlags="\
        --libdir=${!outputLib}/lib --libexecdir=${!outputLib}/libexec \
        --bindir=${!outputBin}/bin --sbindir=${!outputBin}/sbin \
        --includedir=${!outputInclude}/include \
        --mandir=${!outputMan}/share/man --infodir=${!outputInfo}/share/info \
        --localedir=${!outputLib}/share/locale \
        -Dauto_features=${mesonAutoFeatures:-enabled} \
        -Dwrap_mode=${mesonWrapMode:-nodownload} \
        $mesonFlags"

    mesonFlags="${crossMesonFlags+$crossMesonFlags }--buildtype=${mesonBuildType:-plain} $mesonFlags"

    echo "meson flags: $mesonFlags ${mesonFlagsArray[@]}"

    meson setup build $mesonFlags "${mesonFlagsArray[@]}"
    cd build

    if ! [[ -v enableParallelBuilding ]]; then
        enableParallelBuilding=1
        echo "meson: enabled parallel building"
    fi

    if ! [[ -v enableParallelInstalling ]]; then
        enableParallelInstalling=1
        echo "meson: enabled parallel installing"
    fi

    runHook postConfigure
}

if [ -z "${dontUseMesonConfigure-}" -a -z "${configurePhase-}" ]; then
    setOutputFlags=
    configurePhase=mesonConfigurePhase
fi
