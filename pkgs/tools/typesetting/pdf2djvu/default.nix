{stdenv, fetchurl, pkgconfig, djvulibre, poppler, fontconfig, libjpeg }:

stdenv.mkDerivation rec {
  version = "0.7.7";
  name = "pdf2djvu-${version}";

  src = fetchurl {
    url = "http://pdf2djvu.googlecode.com/files/pdf2djvu_${version}.tar.gz";
    sha256 = "17fi5yq936hgjby5jp2hsb1inqqxab4mh58lkxvf1jkrrz658za5";
  };

  buildInputs = [ pkgconfig djvulibre poppler fontconfig libjpeg ];

  meta = {
    description = "Creates djvu files from PDF files";
    homepage = http://code.google.com/p/pdf2djvu/;
    license = "GPLv2";
  };
}
