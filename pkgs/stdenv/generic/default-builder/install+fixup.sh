######################################################################
# install and fixup phases


installPhase() {
    runHook preInstall

    if [ -n "$prefix" ]; then
        mkdir -p "$prefix"
    fi

    installTargets=${installTargets:-install}
    echo "install flags: $installTargets $makeFlags ${makeFlagsArray[@]} $installFlags ${installFlagsArray[@]}"
    make ${makefile:+-f $makefile} $installTargets \
        $makeFlags "${makeFlagsArray[@]}" \
        $installFlags "${installFlagsArray[@]}"

    runHook postInstall
}


# The fixup phase performs generic, package-independent stuff, like
# stripping binaries, running patchelf and setting propagated-build-inputs.
fixupPhase() {
    # Make sure everything is writable so "strip" et al. work.
    for output in $outputs; do
        if [ -e "${!output}" ]; then chmod -R u+w "${!output}"; fi
    done

    runHook preFixup

    # Apply fixup to each output.
    local output
    for output in $outputs; do
        prefix=${!output} runHook fixupOutput
    done

    # Multiple-output derivations mostly choose $dev instead of $out
    local prOut="${propagateIntoOutput:-$out}"

    if [ -n "$propagatedBuildInputs" ]; then
        mkdir -p "$prOut/nix-support"
        echo "$propagatedBuildInputs" > "$prOut/nix-support/propagated-build-inputs"
    fi

    if [ -n "$propagatedNativeBuildInputs" ]; then
        mkdir -p "$prOut/nix-support"
        echo "$propagatedNativeBuildInputs" > "$prOut/nix-support/propagated-native-build-inputs"
    fi

    if [ -n "$propagatedUserEnvPkgs" ]; then
        mkdir -p "$prOut/nix-support"
        echo "$propagatedUserEnvPkgs" > "$prOut/nix-support/propagated-user-env-packages"
    fi

    if [ -n "$setupHook" ]; then
        mkdir -p "$prOut/nix-support"
        substituteAll "$setupHook" "$prOut/nix-support/setup-hook"
    fi

    runHook postFixup
}

