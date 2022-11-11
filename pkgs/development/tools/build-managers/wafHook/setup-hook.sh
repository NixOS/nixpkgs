wafConfigurePhase() {
    runHook preConfigure

    if ! [ -f "${wafPath:=./waf}" ]; then
        echo "copying waf to $wafPath..."
        cp @waf@/bin/waf "$wafPath"
    fi

    if [ -z "${dontAddPrefix:-}" ] && [ -n "$prefix" ]; then
        wafConfigureFlags="${prefixKey:---prefix=}$prefix $wafConfigureFlags"
    fi

    if [ -n "${PKG_CONFIG}" ]; then
      export PKGCONFIG="${PKG_CONFIG}"
    fi

    local flagsArray=(
        "${flagsArray[@]}"
        $wafConfigureFlags "${wafConfigureFlagsArray[@]}"
        ${configureTargets:-configure}
    )
    if [ -z "${dontAddWafCrossFlags:-}" ]; then
        flagsArray+=(@crossFlags@)
    fi
    echoCmd 'configure flags' "${flagsArray[@]}"
    python "$wafPath" "${flagsArray[@]}"

    if ! [[ -v enableParallelBuilding ]]; then
        enableParallelBuilding=1
        echo "waf: enabled parallel building"
    fi

    runHook postConfigure
}

if [ -z "${dontUseWafConfigure-}" -a -z "${configurePhase-}" ]; then
    configurePhase=wafConfigurePhase
fi

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

if [ -z "${dontUseWafBuild-}" -a -z "${buildPhase-}" ]; then
    buildPhase=wafBuildPhase
fi

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

if [ -z "${dontUseWafInstall-}" -a -z "${installPhase-}" ]; then
    installPhase=wafInstallPhase
fi
