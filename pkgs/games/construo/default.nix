{ stdenv, fetchurl, libX11, zlib, xproto, mesa ? null, freeglut ? null }:

stdenv.mkDerivation rec {
  name = "construo-0.2.2";

  src = fetchurl {
    url = http://savannah.nongnu.org/download/construo/construo-0.2.2.tar.gz;
    sha256 = "0c661rjasax4ykw77dgqj39jhb4qi48m0bhhdy42vd5a4rfdrcck";
  };

  buildInputs = [ libX11 zlib xproto ]
    ++ stdenv.lib.optional (mesa != null) mesa
    ++ stdenv.lib.optional (freeglut != null) freeglut;

  preConfigure = ''
    sed -e 's/math[.]h/cmath/' -i vector.cxx
    sed -e 's/games/bin/' -i Makefile.in
    sed -e '1i\#include <stdlib.h>' -i construo_main.cxx -i command_line.cxx -i config.hxx
    sed -e '1i\#include <string.h>' -i command_line.cxx -i lisp_reader.cxx -i unix_system.cxx \
      -i world.cxx construo_main.cxx
  '';

  meta = {
    description = "Masses and springs simulation game";
  };
}
