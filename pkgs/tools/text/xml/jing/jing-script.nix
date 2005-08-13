{stdenv, fetchurl, j2re, unzip} :

stdenv.mkDerivation {
  name = "jing-tools-20030619";
  builder = ./script-builder.sh;

  jing = (import ./default.nix) {
    inherit stdenv fetchurl unzip;
  };

  inherit j2re;
}