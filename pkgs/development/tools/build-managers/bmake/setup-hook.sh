<<<<<<< HEAD
# shellcheck shell=bash disable=SC2086,SC2154,SC2206

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
addMakeFlags() {
    export prefix="$out"
    export MANDIR="${!outputMan}/share/man"
    export MANTARGET=man
    export BINOWN=
    export STRIP_FLAG=
}

<<<<<<< HEAD
=======
preConfigureHooks+=(addMakeFlags)

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
bmakeBuildPhase() {
    runHook preBuild

    local flagsArray=(
        ${enableParallelBuilding:+-j${NIX_BUILD_CORES}}
<<<<<<< HEAD
        SHELL="$SHELL"
=======
        SHELL=$SHELL
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
        $buildFlags ${buildFlagsArray+"${buildFlagsArray[@]}"}
    )

    echoCmd 'build flags' "${flagsArray[@]}"
    bmake ${makefile:+-f $makefile} "${flagsArray[@]}"
<<<<<<< HEAD
=======
    unset flagsArray
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    runHook postBuild
}

<<<<<<< HEAD
=======
if [ -z "${dontUseBmakeBuild-}" -a -z "${buildPhase-}" ]; then
    buildPhase=bmakeBuildPhase
fi

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
bmakeCheckPhase() {
    runHook preCheck

    if [ -z "${checkTarget:-}" ]; then
        #TODO(@oxij): should flagsArray influence make -n?
        if bmake -n ${makefile:+-f $makefile} check >/dev/null 2>&1; then
<<<<<<< HEAD
            checkTarget="check"
        elif bmake -n ${makefile:+-f $makefile} test >/dev/null 2>&1; then
            checkTarget="test"
=======
            checkTarget=check
        elif bmake -n ${makefile:+-f $makefile} test >/dev/null 2>&1; then
            checkTarget=test
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        fi
    fi

    if [ -z "${checkTarget:-}" ]; then
        echo "no test target found in bmake, doing nothing"
    else
<<<<<<< HEAD
        local flagsArray=(
            ${enableParallelChecking:+-j${NIX_BUILD_CORES}}
            SHELL="$SHELL"
=======
        # shellcheck disable=SC2086
        local flagsArray=(
            ${enableParallelChecking:+-j${NIX_BUILD_CORES}}
            SHELL=$SHELL
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
            # Old bash empty array hack
            $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
            ${checkFlags:-VERBOSE=y} ${checkFlagsArray+"${checkFlagsArray[@]}"}
            ${checkTarget}
        )

        echoCmd 'check flags' "${flagsArray[@]}"
        bmake ${makefile:+-f $makefile} "${flagsArray[@]}"
<<<<<<< HEAD
=======

        unset flagsArray
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    fi

    runHook postCheck
}

<<<<<<< HEAD
=======
if [ -z "${dontUseBmakeCheck-}" -a -z "${checkPhase-}" ]; then
    checkPhase=bmakeCheckPhase
fi

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
bmakeInstallPhase() {
    runHook preInstall

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

<<<<<<< HEAD
    local flagsArray=(
        ${enableParallelInstalling:+-j${NIX_BUILD_CORES}}
        SHELL="$SHELL"
=======
    # shellcheck disable=SC2086
    local flagsArray=(
        ${enableParallelInstalling:+-j${NIX_BUILD_CORES}}
        SHELL=$SHELL
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        # Old bash empty array hack
        $makeFlags ${makeFlagsArray+"${makeFlagsArray[@]}"}
        $installFlags ${installFlagsArray+"${installFlagsArray[@]}"}
        ${installTargets:-install}
    )

    echoCmd 'install flags' "${flagsArray[@]}"
    bmake ${makefile:+-f $makefile} "${flagsArray[@]}"
<<<<<<< HEAD
=======
    unset flagsArray
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    runHook postInstall
}

<<<<<<< HEAD
=======
if [ -z "${dontUseBmakeInstall-}" -a -z "${installPhase-}" ]; then
    installPhase=bmakeInstallPhase
fi

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
bmakeDistPhase() {
    runHook preDist

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    # Old bash empty array hack
<<<<<<< HEAD
=======
    # shellcheck disable=SC2086
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    local flagsArray=(
        $distFlags ${distFlagsArray+"${distFlagsArray[@]}"} ${distTarget:-dist}
    )

    echo 'dist flags: %q' "${flagsArray[@]}"
    bmake ${makefile:+-f $makefile} "${flagsArray[@]}"

    if [ "${dontCopyDist:-0}" != 1 ]; then
        mkdir -p "$out/tarballs"

        # Note: don't quote $tarballs, since we explicitly permit
        # wildcards in there.
<<<<<<< HEAD
=======
        # shellcheck disable=SC2086
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        cp -pvd ${tarballs:-*.tar.gz} "$out/tarballs"
    fi

    runHook postDist
}

<<<<<<< HEAD
preConfigureHooks+=(addMakeFlags)

if [ -z "${dontUseBmakeBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=bmakeBuildPhase
fi

if [ -z "${dontUseBmakeCheck-}" ] && [ -z "${checkPhase-}" ]; then
    checkPhase=bmakeCheckPhase
fi

if [ -z "${dontUseBmakeInstall-}" ] && [ -z "${installPhase-}" ]; then
    installPhase=bmakeInstallPhase
fi

if [ -z "${dontUseBmakeDist-}" ] && [ -z "${distPhase-}" ]; then
=======
if [ -z "${dontUseBmakeDist-}" -a -z "${distPhase-}" ]; then
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    distPhase=bmakeDistPhase
fi
