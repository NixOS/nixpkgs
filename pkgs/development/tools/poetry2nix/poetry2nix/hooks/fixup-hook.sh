poetry2nix-fixup-hook() {
    # Including tests in the output is a common mistake
    if [ -z "${dontFixupTests-}" ]; then
        rm -rf $out/lib/python3.7/site-packages/tests
    fi
}

postFixupHooks+=(poetry2nix-fixup-hook)
