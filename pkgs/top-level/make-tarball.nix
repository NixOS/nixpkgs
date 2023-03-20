/* Hydra job to build a tarball for Nixpkgs from a Git checkout.  It
   also builds the documentation and tests whether the Nix expressions
   evaluate correctly. */

{ nixpkgs
, officialRelease
, supportedSystems
, pkgs ? import nixpkgs.outPath {}
, nix ? pkgs.nix
, lib-tests ? import ../../lib/tests/release.nix { inherit pkgs; }
}:

pkgs.releaseTools.sourceTarball {
  name = "nixpkgs-tarball";
  src = nixpkgs;

  inherit officialRelease;
  version = pkgs.lib.fileContents ../../.version;
  versionSuffix = "pre${
    if nixpkgs ? lastModified
    then builtins.substring 0 8 (nixpkgs.lastModifiedDate or nixpkgs.lastModified)
    else toString nixpkgs.revCount}.${nixpkgs.shortRev or "dirty"}";

  buildInputs = with pkgs; [ nix.out jq lib-tests brotli ];

  configurePhase = ''
    eval "$preConfigure"
    releaseName=nixpkgs-$VERSION$VERSION_SUFFIX
    echo -n $VERSION_SUFFIX > .version-suffix
    echo -n ${nixpkgs.rev or nixpkgs.shortRev or "dirty"} > .git-revision
    echo "release name is $releaseName"
    echo "git-revision is $(cat .git-revision)"
  '';

  nixpkgs-basic-release-checks = import ./nixpkgs-basic-release-checks.nix
   { inherit nix pkgs nixpkgs supportedSystems; };

  dontBuild = false;

  doCheck = true;

  checkPhase = ''
    set -o pipefail

    export NIX_STATE_DIR=$TMPDIR
    export NIX_PATH=nixpkgs=$TMPDIR/barf.nix
    opts=(--option build-users-group "")
    nix-store --init

    echo "checking eval-release.nix"
    nix-instantiate --eval --strict --show-trace ./maintainers/scripts/eval-release.nix > /dev/null

    echo "checking find-tarballs.nix"
    nix-instantiate --readonly-mode --eval --strict --show-trace --json \
       ./maintainers/scripts/find-tarballs.nix \
      --arg expr 'import ./maintainers/scripts/all-tarballs.nix' > $TMPDIR/tarballs.json
    nrUrls=$(jq -r '.[].url' < $TMPDIR/tarballs.json | wc -l)
    echo "found $nrUrls URLs"
    if [ "$nrUrls" -lt 10000 ]; then
      echo "suspiciously low number of URLs"
      exit 1
    fi

    echo "generating packages.json"
    mkdir -p $out/nix-support
    echo -n '{"version":2,"packages":' > tmp
    nix-env -f . -I nixpkgs=$src -qa --meta --json --show-trace --arg config 'import ${./packages-config.nix}' "''${opts[@]}" >> tmp
    echo -n '}' >> tmp
    packages=$out/packages.json.br
    < tmp sed "s|$(pwd)/||g" | jq -c | brotli -9 > $packages
    rm tmp

    echo "file json-br $packages" >> $out/nix-support/hydra-build-products
  '';

  distPhase = ''
    mkdir -p $out/tarballs
    mkdir ../$releaseName
    cp -prd . ../$releaseName
    (cd .. && tar cfa $out/tarballs/$releaseName.tar.xz $releaseName) || false
  '';

  meta = {
    maintainers = [ ];
  };
}
