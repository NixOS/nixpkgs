justBuildPhase() {
    runHook preBuild

    local flagsArray=($justFlags "${justFlagsArray[@]}")

    echoCmd 'build flags' "${flagsArray[@]}"
    just "${flagsArray[@]}"

    runHook postBuild
}

justCheckPhase() {
    runHook preCheck

    if [ -z "${checkTarget:-}" ]; then
        if just -n test >/dev/null 2>&1; then
            checkTarget=test
        fi
    fi

    if [ -z "${checkTarget:-}" ]; then
        echo "no test target found in just, doing nothing"
    else
        local flagsArray=(
            $justFlags "${justFlagsArray[@]}"
            $checkTarget
        )

        echoCmd 'check flags' "${flagsArray[@]}"
        just "${flagsArray[@]}"
    fi

    runHook postCheck
}

justInstallPhase() {
    runHook preInstall

    # shellcheck disable=SC2086
    local flagsArray=($justFlags "${justFlagsArray[@]}" ${installTargets:-install})

    echoCmd 'install flags' "${flagsArray[@]}"
    just "${flagsArray[@]}"

    runHook postInstall
}

if [ -z "${dontUseJustBuild-}" -a -z "${buildPhase-}" ]; then
    buildPhase=justBuildPhase
fi

if [ -z "${dontUseJustCheck-}" -a -z "${checkPhase-}" ]; then
    checkPhase=justCheckPhase
fi

if [ -z "${dontUseJustInstall-}" -a -z "${installPhase-}" ]; then
    installPhase=justInstallPhase
fi
