# shellcheck shell=bash disable=SC2164

gnConfigurePhase() {
    runHook preConfigure

    local flagsArray=()
    concatTo flagsArray gnFlags gnFlagsArray

    echoCmd 'gn flags' "${flagsArray[@]}"

    gn gen out/Release --args="${flagsArray[*]}"
    cd out/Release/

    runHook postConfigure
}

if [ -z "${dontUseGnConfigure-}" ] && [ -z "${configurePhase-}" ]; then
    configurePhase=gnConfigurePhase
fi
