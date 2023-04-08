addMakeFlags() {
    export prefix="$out"
    export MANDIR="${!outputMan}/share/man"
    export MANTARGET=man
    export BINOWN=
    export STRIP_FLAG=
}

preConfigureHooks+=(addMakeFlags)

bmakeBuildPhase() {
    runHook preBuild

    local flagsArray=(
        ${enableParallelBuilding:+-j${NIX_BUILD_CORES}}
        SHELL=$SHELL
        $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
        $buildFlags ${buildFlagsArray+"${buildFlagsArray[@]}"}
    )

    echoCmd 'build flags' "${flagsArray[@]}"
    bmake ${makefile:+-f $makefile} "${flagsArray[@]}"
    unset flagsArray

    runHook postBuild
}

if [ -z "${dontUseBmakeBuild-}" -a -z "${buildPhase-}" ]; then
    buildPhase=bmakeBuildPhase
fi

bmakeCheckPhase() {
    runHook preCheck

    if [ -z "${checkTarget:-}" ]; then
        #TODO(@oxij): should flagsArray influence make -n?
        if bmake -n ${makefile:+-f $makefile} check >/dev/null 2>&1; then
            checkTarget=check
        elif bmake -n ${makefile:+-f $makefile} test >/dev/null 2>&1; then
            checkTarget=test
        fi
    fi

    if [ -z "${checkTarget:-}" ]; then
        echo "no test target found in bmake, doing nothing"
    else
        # shellcheck disable=SC2086
        local flagsArray=(
            ${enableParallelChecking:+-j${NIX_BUILD_CORES}}
            SHELL=$SHELL
            # Old bash empty array hack
            $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
            ${checkFlags:-VERBOSE=y} ${checkFlagsArray+"${checkFlagsArray[@]}"}
            ${checkTarget}
        )

        echoCmd 'check flags' "${flagsArray[@]}"
        bmake ${makefile:+-f $makefile} "${flagsArray[@]}"

        unset flagsArray
    fi

    runHook postCheck
}

if [ -z "${dontUseBmakeCheck-}" -a -z "${checkPhase-}" ]; then
    checkPhase=bmakeCheckPhase
fi

bmakeInstallPhase() {
    runHook preInstall

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    # shellcheck disable=SC2086
    local flagsArray=(
        ${enableParallelInstalling:+-j${NIX_BUILD_CORES}}
        SHELL=$SHELL
        # Old bash empty array hack
        $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
        $installFlags ${installFlagsArray+"${installFlagsArray[@]}"}
        ${installTargets:-install}
    )

    echoCmd 'install flags' "${flagsArray[@]}"
    bmake ${makefile:+-f $makefile} "${flagsArray[@]}"
    unset flagsArray

    runHook postInstall
}

if [ -z "${dontUseBmakeInstall-}" -a -z "${installPhase-}" ]; then
    installPhase=bmakeInstallPhase
fi

bmakeDistPhase() {
    runHook preDist

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    # Old bash empty array hack
    # shellcheck disable=SC2086
    local flagsArray=(
        $distFlags ${distFlagsArray+"${distFlagsArray[@]}"} ${distTarget:-dist}
    )

    echo 'dist flags: %q' "${flagsArray[@]}"
    bmake ${makefile:+-f $makefile} "${flagsArray[@]}"

    if [ "${dontCopyDist:-0}" != 1 ]; then
        mkdir -p "$out/tarballs"

        # Note: don't quote $tarballs, since we explicitly permit
        # wildcards in there.
        # shellcheck disable=SC2086
        cp -pvd ${tarballs:-*.tar.gz} "$out/tarballs"
    fi

    runHook postDist
}

if [ -z "${dontUseBmakeDist-}" -a -z "${distPhase-}" ]; then
    distPhase=bmakeDistPhase
fi
