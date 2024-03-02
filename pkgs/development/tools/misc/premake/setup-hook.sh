premakeConfigurePhase() {
    runHook preConfigure

    local flagsArray=(
        ${premakefile:+--file=$premakefile}
        $premakeFlags ${premakeFlagsArray[@]}
        ${premakeBackend:-gmake}
    )

    echoCmd 'configure flags' "${flagsArray[@]}"

    @premake_cmd@ "${flagsArray[@]}"

    runHook postConfigure
}

if [ -z "${configurePhase-}" ]; then
    configurePhase=premakeConfigurePhase
fi
