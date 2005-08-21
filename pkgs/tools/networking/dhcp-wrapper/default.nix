{stdenv, dhcp}:

stdenv.mkDerivation {
  name = dhcp.name;

  builder = ./builder.sh;
  makeWrapper = ../../../build-support/make-wrapper/make-wrapper.sh;

  inherit dhcp;
}
