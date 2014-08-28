######################################################################
# Exit handling both on success or failure.

trap "exitHandler" EXIT

exitHandler() {
    exitCode=$?
    set +e

    closeNest

    if [ -n "$showBuildStats" ]; then
        times > "$NIX_BUILD_TOP/.times"
        local -a times=($(cat "$NIX_BUILD_TOP/.times"))
        # Print the following statistics:
        # - user time for the shell
        # - system time for the shell
        # - user time for all child processes
        # - system time for all child processes
        echo "build time elapsed: " ${times[*]}
    fi

    if [ $exitCode != 0 ]; then
        runHook failureHook

        # If the builder had a non-zero exit code and
        # $succeedOnFailure is set, create the file
        # `$out/nix-support/failed' to signal failure, and exit
        # normally.  Otherwise, return the original exit code.
        if [ -n "$succeedOnFailure" ]; then
            echo "build failed with exit code $exitCode (ignored)"
            mkdir -p "$out/nix-support"
            echo -n $exitCode > "$out/nix-support/failed"
            exit 0
        fi

    else
        runHook successHook
    fi

    exit $exitCode
}


