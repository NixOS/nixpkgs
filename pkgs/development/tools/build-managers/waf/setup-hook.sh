wafConfigurePhase() {
    runHook preConfigure

    if ! [ -f ./waf ]; then
        cp @waf@ waf
    fi

    if [[ -z "${dontAddPrefix:-}" && -n "$prefix" ]]; then
        configureFlags="${prefixKey:---prefix=}$prefix $configureFlags"
    fi

    local flagsArray=(
        $configureFlags ${configureFlagsArray[@]}
        ${configureTargets:-configure}
    )
    echoCmd 'configure flags' "${flagsArray[@]}"
    python waf "${flagsArray[@]}"

    runHook postConfigure
}

wafBuildPhase () {
    runHook preBuild

    # set to empty if unset
    : ${wafFlags=}

    local flagsArray=(
      ${enableParallelBuilding:+-j ${NIX_BUILD_CORES}}
      $wafFlags ${wafFlagsArray[@]}
      $buildFlags ${buildFlagsArray[@]}
      ${buildTargets:-build}
    )

    echoCmd 'build flags' "${flagsArray[@]}"
    python waf "${flagsArray[@]}"

    runHook postBuild
}

wafInstallPhase() {
    runHook preInstall

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    local flagsArray=(
        $wafFlags ${wafFlagsArray[@]}
        $installFlags ${installFlagsArray[@]}
	${installTargets:-install}
    )

    echoCmd 'install flags' "${flagsArray[@]}"
    python waf "${flagsArray[@]}"

    runHook postInstall
}

configurePhase=wafConfigurePhase
buildPhase=wafBuildPhase
installPhase=wafInstallPhase
