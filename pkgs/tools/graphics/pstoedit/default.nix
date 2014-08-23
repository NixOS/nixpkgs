{ stdenv, fetchurl, pkgconfig, ghostscript, gd, zlib, plotutils }:

stdenv.mkDerivation {
  name = "pstoedit-3.62";

  src = fetchurl {
    url = mirror://sourceforge/pstoedit/pstoedit-3.62.tar.gz;
    sha256 = "0j410dm9nqwa7n03yiyz0jwvln0jlqc3n9iv4nls33yl6x3c8x40";
  };

  buildInputs = [ pkgconfig ghostscript gd zlib plotutils ];

  meta = { 
    description = "translates PostScript and PDF graphics into other vector formats";
    homepage = http://www.helga-glunz.homepage.t-online.de/pstoedit;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
