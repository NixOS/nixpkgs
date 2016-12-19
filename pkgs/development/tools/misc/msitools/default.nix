{stdenv, fetchurl, intltool, glib, pkgconfig, libgsf, libuuid, gcab, bzip2}:

stdenv.mkDerivation rec {
  version = "0.94";
  name = "msitools-${version}";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/msitools/0.94/${name}.tar.xz";
    sha256 = "0bndnm3mgcqkw5dhwy5l1zri4lqvjbhbn5rxz651fkxlkhab8bhm";
  };

  buildInputs = [intltool glib pkgconfig libgsf libuuid gcab bzip2];

  meta = with stdenv.lib; {
    description = "Set of programs to inspect and build Windows Installer (.MSI) files";
    homepage = https://wiki.gnome.org/msitools;
    license = [licenses.gpl2 licenses.lgpl21];
    maintainer = [maintainers.vcunat];
    platforms = platforms.unix;
  };
}
