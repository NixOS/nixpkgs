# shellcheck shell=bash

premakeConfigurePhase() {
    runHook preConfigure

    local flagsArray=(
        ${premakefile:+--file=$premakefile}
    )
    : "${premakeBackend:=gmake}"
    concatTo flagsArray premakeFlags premakeFlagsArray premakeBackend

    echoCmd 'configure flags' "${flagsArray[@]}"

    @premake_cmd@ "${flagsArray[@]}"

    runHook postConfigure
}

if [ -z "${configurePhase-}" ]; then
    configurePhase=premakeConfigurePhase
fi
