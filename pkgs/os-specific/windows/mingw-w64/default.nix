{ stdenv, callPackage, windows }:

stdenv.mkDerivation {
  inherit (callPackage ./common.nix {}) name src;
  buildInputs = [ windows.mingw_w64_headers ];
  dontStrip = true;
}
