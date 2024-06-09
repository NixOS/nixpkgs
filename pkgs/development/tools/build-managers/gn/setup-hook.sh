gnConfigurePhase() {
    runHook preConfigure

    local flagsArray=()
    concatTo flagsArray gnFlags gnFlagsArray

    echoCmd 'gn flags' "${flagsArray[@]}"

    gn gen out/Release --args="${flagsArray[*]}"
    cd out/Release/

    runHook postConfigure
}

if [ -z "${dontUseGnConfigure-}" -a -z "${configurePhase-}" ]; then
    configurePhase=gnConfigurePhase
fi
