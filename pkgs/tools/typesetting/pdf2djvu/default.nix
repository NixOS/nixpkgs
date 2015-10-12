{ stdenv, fetchurl, pkgconfig, djvulibre, poppler, fontconfig, libjpeg }:

stdenv.mkDerivation rec {
  version = "0.9.1";
  name = "pdf2djvu-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/jwilk/pdf2djvu/downloads/${name}.tar.xz";
    sha256 = "1x9xqqwq024k2y8jmwrrkcvrfcy0rwh421x4kz2g8i72gzlik6cz";
  };

  buildInputs = [ pkgconfig djvulibre poppler fontconfig libjpeg ];

  meta = with stdenv.lib; {
    description = "Creates djvu files from PDF files";
    homepage = http://code.google.com/p/pdf2djvu/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ pSub ];
    inherit version;
  };
}
