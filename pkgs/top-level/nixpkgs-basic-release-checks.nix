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

    # Make sure that no paths collide on case-preserving or case-insensitive filesysytems.
    conflictingPaths=$(find $src | awk '{ print $1 " " tolower($1) }' | sort -k2 | uniq -D -f 1 | cut -d ' ' -f 1)
    if [[ -n $conflictingPaths ]]; then
        echo "Files in nixpkgs must not vary only by case"
        echo "The offending paths: $conflictingPaths"
        exit 1
    fi

    src2=$TMPDIR/foo
    cp -rd $src $src2

    # Check that all-packages.nix evaluates on a number of platforms without any warnings.
    for platform in ${pkgs.lib.concatStringsSep " " supportedSystems}; do
        header "checking Nixpkgs on $platform"

        # To get a call trace; see https://nixos.org/manual/nixpkgs/stable/#function-library-lib.trivial.warn
        # Relies on impure eval
        export NIX_ABORT_ON_WARN=true

        set +e
        (
          set -x
          nix-env -f $src \
              --show-trace --argstr system "$platform" \
              --arg config '{ allowAliases = false; }' \
              --option experimental-features 'no-url-literals' \
              -qa --drv-path --system-filter \* --system \
              "''${opts[@]}" 2> eval-warnings.log > packages1
        )
        rc=$?
        set -e
        if [ "$rc" != "0" ]; then
          cat eval-warnings.log
          exit $rc
        fi

        s1=$(sha1sum packages1 | cut -c1-40)
        echo $s1

        nix-env -f $src2 \
            --show-trace --argstr system "$platform" \
            --arg config '{ allowAliases = false; }' \
            --option experimental-features 'no-url-literals' \
            -qa --drv-path --system-filter \* --system \
            "''${opts[@]}" > packages2

        s2=$(sha1sum packages2 | cut -c1-40)

        if [[ $s1 != $s2 ]]; then
            echo "Nixpkgs evaluation depends on Nixpkgs path"
            diff packages1 packages2
            exit 1
        fi

        # Catch any trace calls not caught by NIX_ABORT_ON_WARN (lib.warn)
        if [ -s eval-warnings.log ]; then
            echo "Nixpkgs on $platform evaluated with warnings, aborting"
            exit 1
        fi
        rm eval-warnings.log

        nix-env -f $src \
            --show-trace --argstr system "$platform" \
            --arg config '{ allowAliases = false; }' \
            --option experimental-features 'no-url-literals' \
            -qa --drv-path --system-filter \* --system --meta --xml \
            "''${opts[@]}" > /dev/null
    done

    touch $out
''
