wafConfigurePhase() {
    runHook preConfigure

    if ! [ -f "${wafPath:=./waf}" ]; then
        echo "copying waf to $wafPath..."
        cp @waf@ "$wafPath"
    fi

    if [[ -z "${dontAddPrefix:-}" && -n "$prefix" ]]; then
        configureFlags="${prefixKey:---prefix=}$prefix $configureFlags"
    fi

    local flagsArray=(@crossFlags@);
    for flag in $configureFlags "${configureFlagsArray[@]}";
    do
        if [[
        # waf does not support these flags, but they are "blindly" added by the
        # pkgsStatic overlay, for example.
              $flag != "--enable-static"
           && $flag != "--disable-static"
           && $flag != "--enable-shared"
           && $flag != "--disable-shared"
        # these flags are added by configurePlatforms but waf just uses them
        # to bail out in cross compilation cases
           && $flag != --build=* 
           && $flag != --host=* 
           ]];
        then
            flagsArray=("${flagsArray[@]}" "$flag");
        fi;
    done
    flagsArray=(
        "${flagsArray[@]}"
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
