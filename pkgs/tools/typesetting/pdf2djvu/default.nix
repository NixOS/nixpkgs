{ stdenv, fetchurl, pkgconfig, djvulibre, poppler, fontconfig, libjpeg }:

stdenv.mkDerivation rec {
  version = "0.9.2";
  name = "pdf2djvu-${version}";

  src = fetchurl {
    url = "https://bitbucket.org/jwilk/pdf2djvu/downloads/${name}.tar.xz";
    sha256 = "0b1rbbxfa8qzggzwmq4m9wykrv5cl74688z95qq9lns35qz2j2b5";
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
