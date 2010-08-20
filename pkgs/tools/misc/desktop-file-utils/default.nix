{ stdenv, fetchurl, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "desktop-file-utils-0.16";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/desktop-file-utils/releases/${name}.tar.bz2";
    sha256 = "18y9am8n43rrnnldd1cy09ls39xz1gx3qczax2c4cjxayx5vwq3r";
  };

  buildInputs = [ pkgconfig glib ];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/desktop-file-utils;
    description = "Command line utilities for working with .desktop files";
  };
}
