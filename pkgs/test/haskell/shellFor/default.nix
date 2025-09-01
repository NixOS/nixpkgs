{
  lib,
  writeText,
  haskellPackages,
  cabal-install,
}:

(haskellPackages.shellFor {
  packages = p: [
    p.constraints
    p.cereal
  ];
  # WARNING: When updating this, make sure that the libraries passed to
  # `extraDependencies` are not actually transitive dependencies of libraries in
  # `packages` above.  We explicitly want to test that it is possible to specify
  # `extraDependencies` that are not in the closure of `packages`.
  extraDependencies = p: { libraryHaskellDepends = [ p.conduit ]; };
  nativeBuildInputs = [ cabal-install ];
  unpackPhase = ''
    sourceRoot=$(pwd)/scratch
    mkdir -p "$sourceRoot"
    cd "$sourceRoot"
    tar -xf ${haskellPackages.constraints.src}
    tar -xf ${haskellPackages.cereal.src}
    cp ${writeText "cabal.project" "packages: constraints* cereal*"} cabal.project
  '';
  buildPhase = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.cabal
    touch $HOME/.cabal/config

    # Check that the extraDependencies.libraryHaskellDepends arg is correctly
    # picked up. This uses ghci to interpret a small Haskell program that uses
    # a package from extraDependencies.
    ghci <<EOF
    :set -XOverloadedStrings
    :m + Conduit
    runResourceT $ connect (yield "done") (sinkFile "outfile")
    EOF

    if [[ "done" != "$(cat outfile)" ]]; then
      echo "ERROR: extraDependencies appear not to be available in the environment"
      exit 1
    fi

    # Check packages arg
    cabal v2-build --offline --verbose constraints cereal --ghc-options="-O0 -j$NIX_BUILD_CORES"
  '';
  installPhase = ''
    touch $out
  '';
}).overrideAttrs
  (oldAttrs: {
    meta =
      let
        oldMeta = oldAttrs.meta or { };
        oldMaintainers = oldMeta.maintainers or [ ];
        additionalMaintainers = with lib.maintainers; [ cdepillabout ];
        allMaintainers = oldMaintainers ++ additionalMaintainers;
      in
      oldMeta
      // {
        maintainers = allMaintainers;
        inherit (cabal-install.meta) platforms;
      };
    # `shellFor` adds a `buildCommand` (via `envFunc -> runCommandCC`), which
    # overrides custom phases. To ensure this test's phases run, we remove
    # that `buildCommand` from the derivation.
    buildCommand = null;
  })
