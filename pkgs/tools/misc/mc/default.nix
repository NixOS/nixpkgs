{stdenv, fetchurl, pkgconfig, glib, ncurses, libX11}:

stdenv.mkDerivation {
  name = "mc-4.6.1";
  src = fetchurl {
    url = http://www.ibiblio.org/pub/Linux/utils/file/managers/mc/mc-4.6.1.tar.gz;
    md5 = "18b20db6e40480a53bac2870c56fc3c4";
  };
  buildInputs = [pkgconfig glib ncurses libX11];
  builder = ./builder.sh;
}
