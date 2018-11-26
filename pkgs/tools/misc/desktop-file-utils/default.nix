{ stdenv, fetchurl, fetchpatch, pkgconfig, glib, libintl }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "desktop-file-utils-0.23";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/desktop-file-utils/releases/${name}.tar.xz";
    sha256 = "119kj2w0rrxkhg4f9cf5waa55jz1hj8933vh47vcjipcplql02bc";
  };

  patches = [
    # Makes font a recognized media type. Committed upstream, but no release has been made.
    (fetchpatch {
      url = "https://gitlab.freedesktop.org/xdg/desktop-file-utils/commit/92af4108750ceaf4191fd54e255885c7d8a78b70.patch";
      sha256 = "14sqy10p5skp6hv4hgiwnj9hpr460250x42k5z0390l6nr6gahsq";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libintl ];

  meta = {
    homepage = http://www.freedesktop.org/wiki/Software/desktop-file-utils;
    description = "Command line utilities for working with .desktop files";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl2;
  };
}
