{stdenv, fetchurl, game, paks, mesa, name}:

stdenv.mkDerivation {
  builder = ./builder.sh;
  inherit game paks mesa name;
  mesaSwitch = ../../../build-support/opengl/mesa-switch.sh;
}
