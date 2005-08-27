{stdenv, mingetty, shadowutils}:

stdenv.mkDerivation {
  name = mingetty.name;

  builder = ./builder.sh;
  makeWrapper = ../../../build-support/make-wrapper/make-wrapper.sh;

  inherit mingetty shadowutils;

}
