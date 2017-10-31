{ stdenvNoCC, callPackage }:

let
  inherit (callPackage ./common.nix {}) name src;

in stdenvNoCC.mkDerivation {
  name = name + "-headers";
  inherit src;

  preConfigure = ''
    cd mingw-w64-headers
  '';
}
