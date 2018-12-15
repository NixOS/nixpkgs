{stdenv, fetchurl, intltool, glib, pkgconfig, libgsf, libuuid, gcab, bzip2}:

stdenv.mkDerivation rec {
  version = "0.98";
  name = "msitools-${version}";

  src = fetchurl {
    url = "https://ftp.gnome.org/pub/GNOME/sources/msitools/0.98/${name}.tar.xz";
    sha256 = "19wb3n3nwkpc6bjr0q3f1znaxsfaqgjbdxxnbx8ic8bb5b49hwac";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [intltool glib libgsf libuuid gcab bzip2];

  meta = with stdenv.lib; {
    description = "Set of programs to inspect and build Windows Installer (.MSI) files";
    homepage = https://wiki.gnome.org/msitools;
    license = [licenses.gpl2 licenses.lgpl21];
    platforms = platforms.unix;
  };
}
