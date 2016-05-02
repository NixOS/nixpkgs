/* Hydra job to build a tarball for Nixpkgs from a Git checkout.  It
   also builds the documentation and tests whether the Nix expressions
   evaluate correctly. */

{ nixpkgs
, officialRelease
, pkgs ? import nixpkgs.outPath {}
, nix ? pkgs.nix
}:

with pkgs;

releaseTools.sourceTarball rec {
  name = "nixpkgs-tarball";
  src = nixpkgs;

  inherit officialRelease;
  version = builtins.readFile ../../.version;
  versionSuffix = "pre${toString nixpkgs.revCount}.${nixpkgs.shortRev}";

  buildInputs = [ nix.out jq ];

  configurePhase = ''
    eval "$preConfigure"
    releaseName=nixpkgs-$VERSION$VERSION_SUFFIX
    echo -n $VERSION_SUFFIX > .version-suffix
    echo "release name is $releaseName"
  '';

  dontBuild = false;

  doCheck = true;

  checkPhase = ''
    export NIX_DB_DIR=$TMPDIR
    export NIX_STATE_DIR=$TMPDIR
    export NIX_PATH=nixpkgs=$TMPDIR/barf.nix
    nix-store --init

    echo 'abort "Illegal use of <nixpkgs> in Nixpkgs."' > $TMPDIR/barf.nix

    # Make sure that Nixpkgs does not use <nixpkgs>
    if grep -r '<nixpkgs\/' pkgs; then
        echo "Nixpkgs is not allowed to use <nixpkgs> to refer to itself."
        exit 1
    fi

    # Make sure that derivation paths do not depend on the Nixpkgs path.
    mkdir $TMPDIR/foo
    ln -s $(readlink -f .) $TMPDIR/foo/bar
    p1=$(nix-instantiate ./. --dry-run -A firefox --show-trace)
    p2=$(nix-instantiate $TMPDIR/foo/bar --dry-run -A firefox)
    if [ "$p1" != "$p2" ]; then
        echo "Nixpkgs evaluation depends on Nixpkgs path ($p1 vs $p2)!"
        exit 1
    fi

    # Run the regression tests in `lib'.
    res="$(nix-instantiate --eval --strict --show-trace lib/tests.nix)"
    if test "$res" != "[ ]"; then
        echo "regression tests for lib failed, got: $res"
        exit 1
    fi

    # Check that all-packages.nix evaluates on a number of platforms without any warnings.
    for platform in i686-linux x86_64-linux x86_64-darwin; do
        header "checking Nixpkgs on $platform"

        NIXPKGS_ALLOW_BROKEN=1 nix-env -f . \
            --show-trace --argstr system "$platform" \
            -qa --drv-path --system-filter \* --system 2>&1 >/dev/null | tee eval-warnings.log

        if [ -s eval-warnings.log ]; then
            echo "Nixpkgs on $platform evaluated with warnings, aborting"
            exit 1
        fi
        rm eval-warnings.log

        NIXPKGS_ALLOW_BROKEN=1 nix-env -f . \
            --show-trace --argstr system "$platform" \
            -qa --drv-path --system-filter \* --system --meta --xml > /dev/null
        stopNest
    done

    header "checking eval-release.nix"
    nix-instantiate --eval --strict --show-trace ./maintainers/scripts/eval-release.nix > /dev/null
    stopNest

    header "checking find-tarballs.nix"
    nix-instantiate --eval --strict --show-trace --json \
       ./maintainers/scripts/find-tarballs.nix \
      --arg expr 'import ./maintainers/scripts/all-tarballs.nix' > $TMPDIR/tarballs.json
    nrUrls=$(jq -r '.[].url' < $TMPDIR/tarballs.json | wc -l)
    echo "found $nrUrls URLs"
    if [ "$nrUrls" -lt 10000 ]; then
      echo "suspiciously low number of URLs"
      exit 1
    fi
    stopNest
  '';

  distPhase = ''
    mkdir -p $out/tarballs
    mkdir ../$releaseName
    cp -prd . ../$releaseName
    (cd .. && tar cfa $out/tarballs/$releaseName.tar.xz $releaseName) || false
  '';

  meta = {
    maintainers = [ lib.maintainers.all ];
  };
}
