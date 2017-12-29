ninjaBuildPhase() {
    runHook preBuild

    if [[ -z "$ninjaFlags" && ! ( -e build.ninja ) ]]; then
        echo "no build.ninja, doing nothing"
    else
        # shellcheck disable=SC2086
        local flagsArray=( \
            ${enableParallelBuilding:+-j${NIX_BUILD_CORES} -l${NIX_BUILD_CORES}} \
            $ninjaFlags "${ninjaFlagsArray[@]}" \
            $buildFlags "${buildFlagsArray[@]}")

        echoCmd 'build flags' "${flagsArray[@]}"
        ninja "${flagsArray[@]}"
        unset flagsArray
    fi

    runHook postBuild
}

if [ -z "$dontUseNinjaBuild" -a -z "$buildPhase" ]; then
    buildPhase=ninjaBuildPhase
fi

ninjaInstallPhase() {
    runHook preInstall

    installTargets="${installTargets:-install}"

    # shellcheck disable=SC2086
    local flagsArray=( $installTargets \
        $ninjaFlags "${ninjaFlagsArray[@]}")

    echoCmd 'install flags' "${flagsArray[@]}"
    ninja "${flagsArray[@]}"
    unset flagsArray

    runHook postInstall
}

if [ -z "$dontUseNinjaInstall" -a -z "$installPhase" ]; then
    installPhase=ninjaInstallPhase
fi
