{ stdenv, fetchurl, pkgconfig, ghostscript, gd, libjpeg, zlib, plotutils }:

stdenv.mkDerivation rec {
  name = "pstoedit-3.62";

  src = fetchurl {
    url = "mirror://sourceforge/pstoedit/${name}.tar.gz";
    sha256 = "0j410dm9nqwa7n03yiyz0jwvln0jlqc3n9iv4nls33yl6x3c8x40";
  };

  buildInputs = [ pkgconfig ghostscript gd libjpeg zlib plotutils ];

  meta = { 
    description = "Translates PostScript and PDF graphics into other vector formats";
    homepage = http://www.helga-glunz.homepage.t-online.de/pstoedit;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.marcweber ];
    platforms = stdenv.lib.platforms.linux;
  };
}
