{ stdenv, fetchurl, pkgconfig, djvulibre, poppler, fontconfig, libjpeg }:

stdenv.mkDerivation rec {
  version = "0.8";
  name = "pdf2djvu-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/jwilk/pdf2djvu/downloads/${name}.tar.xz";
    sha256 = "0xdxx5c7hvhzfmi37cf9p17smm2y55wc8z1vsncqqvf1sxqpjmbn";
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
