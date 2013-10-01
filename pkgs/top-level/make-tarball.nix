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
  versionSuffix = "pre${toString nixpkgs.revCount}_${nixpkgs.shortRev}";

  buildInputs = [
    lzma
    libxml2 # Needed for the release notes.
    libxslt
    w3m
    nix # Needed to check whether the expressions are valid.
    tetex dblatex
  ];

  configurePhase = ''
    eval "$preConfigure"
    releaseName=nixpkgs-$VERSION$VERSION_SUFFIX
    echo -n $VERSION_SUFFIX > .version-suffix
    echo "release name is $releaseName"
  '';

  dontBuild = false;

  buildPhase = ''
    echo "building docs..."
    export VARTEXFONTS=$TMPDIR/texfonts
    make -C doc docbookxsl=${docbook5_xsl}/xml/xsl/docbook
    ln -s doc/NEWS.txt NEWS
  '';

  doCheck = true;

  checkPhase = ''
    export NIX_DB_DIR=$TMPDIR
    export NIX_STATE_DIR=$TMPDIR
    nix-store --init

    # Run the regression tests in `lib'.
    res="$(nix-instantiate --eval-only --strict --show-trace lib/tests.nix)"
    if test "$res" != "[ ]"; then
        echo "regression tests for lib failed, got: $res"
        exit 1
    fi

    # Check that all-packages.nix evaluates on a number of platforms.
    for platform in i686-linux x86_64-linux x86_64-darwin i686-freebsd x86_64-freebsd; do
        header "checking pkgs/top-level/all-packages.nix on $platform"
        nix-env --readonly-mode -f pkgs/top-level/all-packages.nix \
            --show-trace --argstr system "$platform" \
            -qa \* --drv-path --system-filter \* --system --meta --xml > /dev/null
        stopNest
    done

    header "checking eval-release.nix"
    nix-instantiate --eval-only --strict --show-trace ./maintainers/scripts/eval-release.nix > /dev/null
    stopNest
  '';

  distPhase = ''
    find . -name "\.svn" -exec rm -rvf {} \; -prune

    mkdir -p $out/tarballs
    mkdir ../$releaseName
    cp -prd . ../$releaseName
    echo nixpkgs > ../$releaseName/channel-name
    (cd .. && tar cfa $out/tarballs/$releaseName.tar.xz $releaseName) || false

    mkdir -p $out/release-notes
    cp doc/NEWS.html $out/release-notes/index.html
    cp doc/style.css $out/release-notes/
    echo "doc release-notes $out/release-notes" >> $out/nix-support/hydra-build-products

    mkdir -p $out/manual
    cp doc/manual.html $out/manual/index.html
    cp doc/style.css $out/manual/
    echo "doc manual $out/manual" >> $out/nix-support/hydra-build-products

    cp doc/manual.pdf $out/manual.pdf
    echo "doc-pdf manual $out/manual.pdf" >> $out/nix-support/hydra-build-products
  '';

  meta = {
    maintainers = [ lib.maintainers.all ];
  };
}
