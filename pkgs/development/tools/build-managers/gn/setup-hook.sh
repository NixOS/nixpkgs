gnConfigurePhase() {
    runHook preConfigure

    echo "gn flags: $gnFlags ${gnFlagsArray[@]}"

    gn gen out/Release --args="$gnFlags ${gnFlagsArray[@]}"
    cd out/Release/

    runHook postConfigure
}

if [ -z "${dontUseGnConfigure-}" -a -z "${configurePhase-}" ]; then
    configurePhase=gnConfigurePhase
fi
