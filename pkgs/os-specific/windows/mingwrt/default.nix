{ stdenv, callPackage }:

stdenv.mkDerivation {
  inherit (callPackage ./common.nix {}) name src meta;
  dontStrip = true;
  hardeningDisable = [ "stackprotector" "fortify" ];
}
