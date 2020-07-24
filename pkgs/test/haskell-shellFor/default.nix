{ stdenv, haskellPackages, cabal-install }:

haskellPackages.shellFor {
  packages = p: [ p.database-id-class p.constraints-extras ];
  nativeBuildInputs = [ cabal-install ];
  phases = [ "unpackPhase" "buildPhase" "installPhase" ];
  unpackPhase = ''
    sourceRoot=$(pwd)/scratch
    mkdir -p "$sourceRoot"
    cd "$sourceRoot"
    tar -xf ${haskellPackages.database-id-class.src}
    tar -xf ${haskellPackages.constraints-extras.src}
    cp ${builtins.toFile "cabal.project" "packages: database-id-class* constraints-extras*"} cabal.project
  '';
  buildPhase = ''
    export HOME=$(mktemp -d)
    mkdir -p $HOME/.cabal
    touch $HOME/.cabal/config
    cabal v2-build --offline --verbose database-id-class constraints-extras --ghc-options="-O0 -j$NIX_BUILD_CORES"
  '';
  installPhase = ''
    touch $out
  '';
}
