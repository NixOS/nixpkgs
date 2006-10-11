{stdenv, fetchurl, game, paks, mesa, name, description}:

stdenv.mkDerivation {
  builder = ./builder.sh;
  inherit game paks mesa name;
  
  mesaSwitch = ../../../build-support/opengl/mesa-switch.sh;

  meta = {
    inherit description;
  };
}
