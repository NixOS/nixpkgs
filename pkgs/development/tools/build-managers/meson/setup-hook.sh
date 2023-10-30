mesonConfigurePhase() {
    runHook preConfigure

    if [ -z "$__structuredAttrs" ]; then
        mesonFlags=(${mesonFlags[*]})
        mesonCheckFlags=(${mesonCheckFlags[*]})
        mesonInstallFlags=(${mesonInstallFlags[*]})
    fi

    if [ -z "${dontAddPrefix-}" ]; then
        mesonFlags=("--prefix=$prefix" "${mesonFlags[@]}")
    fi

    # See multiple-outputs.sh and meson’s coredata.py
    mesonFlags=(
        "--libdir=${!outputLib}/lib" "--libexecdir=${!outputLib}/libexec"
        "--bindir=${!outputBin}/bin" "--sbindir=${!outputBin}/sbin"
        "--includedir=${!outputInclude}/include"
        "--mandir=${!outputMan}/share/man" "--infodir=${!outputInfo}/share/info"
        "--localedir=${!outputLib}/share/locale"
        "-Dauto_features=${mesonAutoFeatures:-enabled}"
        "-Dwrap_mode=${mesonWrapMode:-nodownload}"
        "${mesonFlags[@]}"
    )

    mesonFlags=("${crossMesonFlags+$crossMesonFlags }--buildtype=${mesonBuildType:-plain}" "${mesonFlags[@]}" "${mesonFlagsArray[@]}")

    echo "meson flags: ${mesonFlags[*]}"

    meson setup build "${mesonFlags[@]}"

    cd build

    if ! [[ -v enableParallelBuilding ]]; then
        enableParallelBuilding=1
        echo "meson: enabled parallel building"
    fi

    if [[ ${checkPhase-ninjaCheckPhase} = ninjaCheckPhase && -z $dontUseMesonCheck ]]; then
        checkPhase=mesonCheckPhase
    fi
    if [[ ${installPhase-ninjaInstallPhase} = ninjaInstallPhase && -z $dontUseMesonInstall ]]; then
        installPhase=mesonInstallPhase
    fi

    runHook postConfigure
}

mesonCheckPhase() {
    runHook preCheck

    local flagsArray=("${mesonCheckFlags[@]}" "${mesonCheckFlagsArray[@]}")

    echoCmd 'check flags' "${flagsArray[@]}"
    meson test --no-rebuild "${flagsArray[@]}"

    runHook postCheck
}

mesonInstallPhase() {
    runHook preInstall

    local flagsArray=("${mesonInstallFlags[@]}" "${mesonInstallFlagsArray[@]}")

    if [ ${#mesonInstallTags[@]} -ne 0 ]; then
        mesonInstallTags="${mesonInstallTags[*]}"
        flagsArray+=("--tags" "${mesonInstallTags// /,}")
    fi

    echoCmd 'install flags' "${flagsArray[@]}"
    meson install --no-rebuild "${flagsArray[@]}"

    runHook postInstall
}

if [ -z "${dontUseMesonConfigure-}" ] && [ -z "${configurePhase-}" ]; then
    setOutputFlags=
    configurePhase=mesonConfigurePhase
fi
