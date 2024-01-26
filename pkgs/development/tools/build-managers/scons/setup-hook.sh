# shellcheck shell=bash disable=SC2206

sconsBuildPhase() {
    runHook preBuild

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    if [ -z "${dontAddPrefix:-}" ] && [ -n "$prefix" ]; then
        buildFlags="${prefixKey:-prefix=}$prefix $buildFlags"
    fi

    local flagsArray=(
      ${enableParallelBuilding:+-j${NIX_BUILD_CORES}}
      $sconsFlags ${sconsFlagsArray[@]}
      $buildFlags ${buildFlagsArray[@]}
    )

    echoCmd 'scons build flags' "${flagsArray[@]}"
    scons "${flagsArray[@]}"

    runHook postBuild
}

sconsInstallPhase() {
    runHook preInstall

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    if [ -z "${dontAddPrefix:-}" ] && [ -n "$prefix" ]; then
        installFlags="${prefixKey:-prefix=}$prefix $installFlags"
    fi

    local flagsArray=(
        ${enableParallelInstalling:+-j${NIX_BUILD_CORES}}
        $sconsFlags ${sconsFlagsArray[@]}
        $installFlags ${installFlagsArray[@]}
        ${installTargets:-install}
    )

    echoCmd 'scons install flags' "${flagsArray[@]}"
    scons "${flagsArray[@]}"

    runHook postInstall
}

sconsCheckPhase() {
    runHook preCheck

    if [ -z "${checkTarget:-}" ]; then
        if scons -n check >/dev/null 2>&1; then
            checkTarget="check"
        elif scons -n test >/dev/null 2>&1; then
            checkTarget="test"
        fi
    fi

    if [ -z "${checkTarget:-}" ]; then
        echo "no check/test target found, doing nothing"
    else
        local flagsArray=(
            ${enableParallelChecking:+-j${NIX_BUILD_CORES}}
            $sconsFlags ${sconsFlagsArray[@]}
            ${checkFlagsArray[@]}
        )

        echoCmd 'scons check flags' "${flagsArray[@]}"
        scons "${flagsArray[@]}"
    fi

    runHook postCheck
}

if [ -z "${dontUseSconsBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=sconsBuildPhase
fi

if [ -z "${dontUseSconsCheck-}" ] && [ -z "${checkPhase-}" ]; then
    checkPhase=sconsCheckPhase
fi

if [ -z "${dontUseSconsInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=sconsInstallPhase
fi
