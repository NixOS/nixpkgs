{stdenv, findutils}:

stdenv.mkDerivation {
  name = findutils.name;

  builder = ./builder.sh;
  makeWrapper = ../../../build-support/make-wrapper/make-wrapper.sh;

  inherit findutils;
}
