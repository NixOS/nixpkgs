{stdenv, grub, diffutils, gnused, gnugrep, coreutils}:

stdenv.mkDerivation {
  name = grub.name;

  builder = ./builder.sh;
  makeWrapper = ../../../build-support/make-wrapper/make-wrapper.sh;

  inherit grub diffutils gnused gnugrep coreutils;
}
