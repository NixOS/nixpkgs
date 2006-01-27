{stdenv, fetchurl, game, paks}:

stdenv.mkDerivation {
  name = "quake3";
  builder = ./builder.sh;
  inherit game paks;
}
