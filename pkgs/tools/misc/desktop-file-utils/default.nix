{ stdenv, fetchurl, pkgconfig, glib, libintl }:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "desktop-file-utils";
  version = "0.24";

  src = fetchurl {
    url = "https://www.freedesktop.org/software/${pname}/releases/${pname}-${version}.tar.xz";
    sha256 = "1nc3bwjdrpcrkbdmzvhckq0yngbcxspwj2n1r7jr3gmx1jk5vpm1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ glib libintl ];

  setupHook = ./setup-hook.sh;

  meta = {
    homepage = "http://www.freedesktop.org/wiki/Software/desktop-file-utils";
    description = "Command line utilities for working with .desktop files";
    platforms = platforms.linux ++ platforms.darwin;
    license = licenses.gpl2;
  };
}
