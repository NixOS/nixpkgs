{ stdenv, fetchurl, pkgconfig, glib, libintl }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "desktop-file-utils-0.23";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/desktop-file-utils/releases/${name}.tar.xz";
    sha256 = "119kj2w0rrxkhg4f9cf5waa55jz1hj8933vh47vcjipcplql02bc";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libintl ];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/desktop-file-utils;
    description = "Command line utilities for working with .desktop files";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
