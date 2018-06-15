{ stdenv, callPackage }:

stdenv.mkDerivation {
  inherit (callPackage ./common.nix {}) name src nativeBuildInputs meta;
  dontStrip = true;
}
