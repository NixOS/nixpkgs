{stdenv, fetchurl, pkgconfig, djvulibre, poppler, fontconfig, libjpeg }:

stdenv.mkDerivation {
  name = "pdf2djvu-0.5.3";

  src = fetchurl {
    url = http://pdf2djvu.googlecode.com/files/pdf2djvu_0.5.3.tar.gz;
    sha256 = "b36b958fc395dc8976485bef09aac2b97435d0d9f21b4cf8dacaa5b55f3f2c1c";
  };

  buildInputs = [ pkgconfig djvulibre poppler fontconfig libjpeg ];

  meta = {
    description = "Creates djvu files from PDF files";
    homepage = http://code.google.com/p/pdf2djvu/;
    license = "GPLv2";
  };
}
