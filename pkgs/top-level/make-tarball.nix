/* Hydra job to build a tarball for Nixpkgs from a SVN checkout.  It
   also builds the documentation and tests whether the Nix expressions
   evaluate correctly. */

{ nixpkgs ? {outPath = (import ./all-packages.nix {}).lib.cleanSource ../..; rev = 1234;}
, officialRelease ? false
}:

with import nixpkgs.outPath {};

releaseTools.makeSourceTarball {
  name = "nixpkgs-tarball";
  src = nixpkgs;
  inherit officialRelease;

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
    releaseName=nixpkgs-$(cat $src/VERSION)$VERSION_SUFFIX
    echo "release name is $releaseName"
    echo $releaseName > relname
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
    # Run the regression tests in `lib'.
    res="$(nix-instantiate --eval-only --strict pkgs/lib/tests.nix)"
    if test "$res" != "List([])"; then
        echo "regression tests for lib failed, got: $res"
        exit 1
    fi
  
    # Check that all-packages.nix evaluates on a number of platforms.
    for platform in i686-linux x86_64-linux powerpc-linux i686-freebsd powerpc-darwin i686-darwin; do
        header "checking pkgs/top-level/all-packages.nix on $platform"
        nix-env --readonly-mode -f pkgs/top-level/all-packages.nix \
            --show-trace --argstr system "$platform" \
            -qa \* --drv-path --system-filter \* --system --meta --xml
        stopNest
    done
  '';

  distPhase = ''
    ensureDir $out/tarballs
    mkdir ../$releaseName
    cp -prd . ../$releaseName
    (cd .. && tar cfa $out/tarballs/$releaseName.tar.bz2 $releaseName) || false
    (cd .. && tar cfa $out/tarballs/$releaseName.tar.lzma $releaseName) || false

    ensureDir $out/release-notes
    cp doc/NEWS.html $out/release-notes/index.html
    cp doc/style.css $out/release-notes/
    echo "doc release-notes $out/release-notes" >> $out/nix-support/hydra-build-products

    ensureDir $out/manual
    cp doc/manual.html $out/manual/index.html
    cp doc/style.css $out/manual/
    echo "doc manual $out/manual" >> $out/nix-support/hydra-build-products

    cp doc/manual.pdf $out/manual.pdf
    echo "doc-pdf manual $out/manual.pdf" >> $out/nix-support/hydra-build-products
  '';

  meta = {
    maintainers = [lib.maintainers.eelco];
  };
}
