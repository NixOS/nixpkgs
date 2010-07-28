{ stdenv, fetchurl, pkgconfig, ghostscript, gd, zlib, plotutils }:

stdenv.mkDerivation {
  name = "pstoedit-3.50";

  src = fetchurl {
    url = http://prdownloads.sourceforge.net/pstoedit/pstoedit-3.50.tar.gz;
    sha256 = "04ap21fxj2zn6vj9mv7zknj4svcbkb1gxwfzxkw5i0sksx969c92";
  };

  buildInputs = [ pkgconfig ghostscript gd zlib plotutils ];

  meta = { 
    description = "translates PostScript and PDF graphics into other vector formats";
    homepage = http://www.helga-glunz.homepage.t-online.de/pstoedit;
    license = "GPLv2";
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
