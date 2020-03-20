wafConfigurePhase() {
    runHook preConfigure

    if ! [ -f "${wafPath:=./waf}" ]; then
        echo "copying waf to $wafPath..."
        cp @waf@/bin/waf "$wafPath"
    fi

    if [ -z "${dontAddPrefix:-}" ] && [ -n "$prefix" ]; then
        wafConfigureFlags="${prefixKey:---prefix=}$prefix $wafConfigureFlags"
    fi

    local flagsArray=(
        @crossFlags@
        "${flagsArray[@]}"
        $wafConfigureFlags "${wafConfigureFlagsArray[@]}"
        ${configureTargets:-configure}
    )
    echoCmd 'configure flags' "${flagsArray[@]}"
    python "$wafPath" "${flagsArray[@]}"

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
    python "$wafPath" "${flagsArray[@]}"

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
    python "$wafPath" "${flagsArray[@]}"

    runHook postInstall
}

configurePhase=wafConfigurePhase
buildPhase=wafBuildPhase
installPhase=wafInstallPhase
