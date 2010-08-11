{stdenv, fetchurl, pkgconfig, djvulibre, poppler, fontconfig, libjpeg }:

stdenv.mkDerivation rec {
  version = "0.7.4";
  name = "pdf2djvu-${version}";

  src = fetchurl {
    url = "http://pdf2djvu.googlecode.com/files/pdf2djvu_${version}.tar.gz";
    sha256 = "4ca375cd4e873d82428bd934ecc7cdbc6331a8236090c2424bd3c3b7bfc1331c";
  };

  buildInputs = [ pkgconfig djvulibre poppler fontconfig libjpeg ];

  meta = {
    description = "Creates djvu files from PDF files";
    homepage = http://code.google.com/p/pdf2djvu/;
    license = "GPLv2";
  };
}
