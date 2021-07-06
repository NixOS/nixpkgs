{ lib, writeText, haskellPackages, cabal-install }:

(haskellPackages.shellFor {
  packages = p: [ p.constraints p.linear ];
  nativeBuildInputs = [ cabal-install ];
  phases = [ "unpackPhase" "buildPhase" "installPhase" ];
  unpackPhase = ''
    sourceRoot=$(pwd)/scratch
    mkdir -p "$sourceRoot"
    cd "$sourceRoot"
    tar -xf ${haskellPackages.constraints.src}
    tar -xf ${haskellPackages.linear.src}
    cp ${writeText "cabal.project" "packages: constraints* linear*"} cabal.project
  '';
  buildPhase = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.cabal
    touch $HOME/.cabal/config
    cabal v2-build --offline --verbose constraints linear --ghc-options="-O0 -j$NIX_BUILD_CORES"
  '';
  installPhase = ''
    touch $out
  '';
}).overrideAttrs (oldAttrs: {
  meta =
    let
      oldMeta = oldAttrs.meta or {};
      oldMaintainers = oldMeta.maintainers or [];
      additionalMaintainers = with lib.maintainers; [ cdepillabout ];
      allMaintainers = oldMaintainers ++ additionalMaintainers;
    in
    oldMeta // { maintainers = allMaintainers; };
})
