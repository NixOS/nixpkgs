{ stdenv, fetchurl, gtk2, pkgconfig, intltool }:

stdenv.mkDerivation rec {
  version = "0.5.4";
  name = "xarchiver-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/xarchiver/${name}.tar.bz2";
    sha256 = "1x1f8m71cvv2p1364rz99iqs2caxj7yrb46aikz6xigwg4wsfgz6";
  };

  buildInputs = [ gtk2 pkgconfig intltool ];

  meta = {
    description = "GTK+2 only frontend to 7z,zip,rar,tar,bzip2, gzip,arj, lha, rpm and deb (open and extract only)";
    homepage = http://sourceforge.net/projects/xarchiver/;
    maintainers = [ stdenv.lib.maintainers.domenkozar ];
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
  };
}
