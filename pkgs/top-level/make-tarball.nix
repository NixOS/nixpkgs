/* Hydra job to build a tarball for Nixpkgs from a Git checkout.  It
   also builds the documentation and tests whether the Nix expressions
   evaluate correctly. */

{ nixpkgs, officialRelease }:

with import nixpkgs.outPath {};

releaseTools.sourceTarball rec {
  name = "nixpkgs-tarball";
  src = nixpkgs;

  inherit officialRelease;
  version = builtins.readFile ../../.version;
  versionSuffix = "pre${toString nixpkgs.revCount}.${nixpkgs.shortRev}";

  buildInputs = [ nix ];

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
    nix-store --init

    # Make sure that derivation paths do not depend on the Nixpkgs path.
    mkdir $TMPDIR/foo
    ln -s $(readlink -f .) $TMPDIR/foo/bar
    p1=$(nix-instantiate pkgs/top-level/all-packages.nix --dry-run -A firefox)
    p2=$(nix-instantiate $TMPDIR/foo/bar/pkgs/top-level/all-packages.nix --dry-run -A firefox)
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

    # Check that all-packages.nix evaluates on a number of platforms.
    for platform in i686-linux x86_64-linux x86_64-darwin i686-freebsd x86_64-freebsd; do
        header "checking pkgs/top-level/all-packages.nix on $platform"
        NIXPKGS_ALLOW_BROKEN=1 nix-env -f pkgs/top-level/all-packages.nix \
            --show-trace --argstr system "$platform" \
            -qa \* --drv-path --system-filter \* --system --meta --xml > /dev/null
        stopNest
    done

    header "checking eval-release.nix"
    nix-instantiate --eval --strict --show-trace ./maintainers/scripts/eval-release.nix > /dev/null
    stopNest

    header "checking find-tarballs.nix"
    nix-instantiate --eval --strict --show-trace ./maintainers/scripts/find-tarballs.nix > /dev/null
    stopNest
  '';

  distPhase = ''
    mkdir -p $out/tarballs
    mkdir ../$releaseName
    cp -prd . ../$releaseName
    echo nixpkgs > ../$releaseName/channel-name
    (cd .. && tar cfa $out/tarballs/$releaseName.tar.xz $releaseName) || false
  '';

  meta = {
    maintainers = [ lib.maintainers.all ];
  };
}
