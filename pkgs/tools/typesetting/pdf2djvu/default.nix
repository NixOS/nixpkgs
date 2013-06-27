{stdenv, fetchurl, pkgconfig, djvulibre, poppler, fontconfig, libjpeg }:

stdenv.mkDerivation rec {
  version = "0.7.16";
  name = "pdf2djvu-${version}";

  src = fetchurl {
    url = "http://pdf2djvu.googlecode.com/files/pdf2djvu_${version}.tar.gz";
    sha256 = "1yg4ppqxpfda89yi4c3rrq2zhar5dzyqypvqdvdd0r7is2321nnv";
  };

  buildInputs = [ pkgconfig djvulibre poppler fontconfig libjpeg ];

  meta = {
    description = "Creates djvu files from PDF files";
    homepage = http://code.google.com/p/pdf2djvu/;
    license = stdenv.lib.licenses.gpl2;
    inherit version;
  };
}
