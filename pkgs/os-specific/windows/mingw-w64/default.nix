{ stdenv, callPackage }:

stdenv.mkDerivation {
  inherit (callPackage ./common.nix {}) name src;
  dontStrip = true;
}
