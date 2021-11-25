{ supportedSystems, nixpkgs, pkgs, nix }:

pkgs.runCommand "nixpkgs-release-checks" { src = nixpkgs; buildInputs = [nix]; } ''
    set -o pipefail

    export NIX_STORE_DIR=$TMPDIR/store
    export NIX_STATE_DIR=$TMPDIR/state
    export NIX_PATH=nixpkgs=$TMPDIR/barf.nix
    opts=(--option build-users-group "")
    nix-store --init

    echo 'abort "Illegal use of <nixpkgs> in Nixpkgs."' > $TMPDIR/barf.nix

    # Make sure that Nixpkgs does not use <nixpkgs>.
    badFiles=$(find $src/pkgs -type f -name '*.nix' -print | xargs grep -l '^[^#]*<nixpkgs\/' || true)
    if [[ -n $badFiles ]]; then
        echo "Nixpkgs is not allowed to use <nixpkgs> to refer to itself."
        echo "The offending files: $badFiles"
        exit 1
    fi

    # Make sure that derivation paths do not depend on the Nixpkgs path.
    mkdir $TMPDIR/foo
    ln -s $(readlink -f $src) $TMPDIR/foo/bar
    p1=$(nix-instantiate $src --dry-run -A firefox --show-trace)
    p2=$(nix-instantiate $TMPDIR/foo/bar --dry-run -A firefox --show-trace)
    if [ "$p1" != "$p2" ]; then
        echo "Nixpkgs evaluation depends on Nixpkgs path ($p1 vs $p2)!"
        exit 1
    fi

    # Check that all-packages.nix evaluates on a number of platforms without any warnings.
    for platform in ${pkgs.lib.concatStringsSep " " supportedSystems}; do
        header "checking Nixpkgs on $platform"

        nix-env -f $src \
            --show-trace --argstr system "$platform" \
            --arg config '{ allowAliases = false; }' \
            -qa --drv-path --system-filter \* --system \
            "''${opts[@]}" 2>&1 >/dev/null | tee eval-warnings.log

        if [ -s eval-warnings.log ]; then
            echo "Nixpkgs on $platform evaluated with warnings, aborting"
            exit 1
        fi
        rm eval-warnings.log

        nix-env -f $src \
            --show-trace --argstr system "$platform" \
            --arg config '{ allowAliases = false; }' \
            -qa --drv-path --system-filter \* --system --meta --xml \
            "''${opts[@]}" > /dev/null
    done

    touch $out
''
