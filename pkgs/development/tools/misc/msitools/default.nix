{stdenv, fetchurl, intltool, glib, pkgconfig, libgsf, libuuid, gcab, bzip2}:

stdenv.mkDerivation rec {
  version = "0.97";
  name = "msitools-${version}";

  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/msitools/0.97/${name}.tar.xz";
    sha256 = "0pn6izlgwi4ngpk9jk2n38gcjjpk29nm15aad89bg9z3k9n2hnrs";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [intltool glib libgsf libuuid gcab bzip2];

  meta = with stdenv.lib; {
    description = "Set of programs to inspect and build Windows Installer (.MSI) files";
    homepage = https://wiki.gnome.org/msitools;
    license = [licenses.gpl2 licenses.lgpl21];
    maintainers = [maintainers.vcunat];
    platforms = platforms.unix;
  };
}
