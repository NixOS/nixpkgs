{stdenv, fetchurl, pkgconfig, djvulibre, poppler, fontconfig, libjpeg }:

stdenv.mkDerivation rec {
  version = "0.7.11";
  name = "pdf2djvu-${version}";

  src = fetchurl {
    url = "http://pdf2djvu.googlecode.com/files/pdf2djvu_${version}.tar.gz";
    sha256 = "00gscd7l02jyr132vlj08ks0pgmh5ja785n3fdxa795cib45rbgq";
  };

  buildInputs = [ pkgconfig djvulibre poppler fontconfig libjpeg ];

  meta = {
    description = "Creates djvu files from PDF files";
    homepage = http://code.google.com/p/pdf2djvu/;
    license = stdenv.lib.licenses.gpl2;
  };
}
