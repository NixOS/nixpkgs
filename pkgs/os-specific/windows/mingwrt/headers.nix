{ stdenvNoCC, callPackage }:

let
  inherit (callPackage ./common.nix {}) name src meta;

in stdenvNoCC.mkDerivation {
  name = name + "-headers";

  inherit src meta;

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out
    cp -R include $out
  '';
}
