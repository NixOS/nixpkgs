genieConfigurePhase() {
    runHook preConfigure

    local flagsArray=(
        $genieFlags ${genieFlagsArray[@]}
        gmake
    )

    echoCmd 'configure flags' "${flagsArray[@]}"
    genie "${flagsArray[@]}"
    runHook postConfigure
}

if [ -z "$configurePhase" ]; then
    configurePhase=genieConfigurePhase
fi
