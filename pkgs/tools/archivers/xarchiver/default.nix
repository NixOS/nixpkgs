{ stdenv, fetchurl, gtk2, pkgconfig, intltool }:

stdenv.mkDerivation rec {
  version = "0.5.3";
  name = "xarchiver-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/xarchiver/${name}.tar.bz2";
    sha256 = "10bdq406xkl2q6rl6qvvipdr3ini5lnh1sjykgw66fp8jns9r2f5";
  };

  buildInputs = [ gtk2 pkgconfig intltool ];

  meta = {
    description = "GTK+2 only frontend to 7z,zip,rar,tar,bzip2, gzip,arj, lha, rpm and deb (open and extract only)";
    homepage = http://sourceforge.net/projects/xarchiver/;
    mainatainers = [ stdenv.lib.maintainers.iElectric ];
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.all;
  };
}
