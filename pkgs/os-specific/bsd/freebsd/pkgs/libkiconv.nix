{ mkDerivation }:
mkDerivation {
  path = "lib/libkiconv";
  extraPaths = [ "sys" ];
}
