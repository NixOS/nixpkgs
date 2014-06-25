{stdenv, fetchurl, pkgconfig, djvulibre, ghostscript }:

stdenv.mkDerivation rec {
  version = "0.9.2";
  name = "djvu2pdf-${version}";

  src = fetchurl {
    url = "http://0x2a.at/site/projects/djvu2pdf/djvu2pdf-${version}.tar.gz";
    sha256 = "0v2ax30m7j1yi4m02nzn9rc4sn4vzqh5vywdh96r64j4pwvn5s5g";
  };

  buildInputs = [ pkgconfig djvulibre ghostscript ];

  meta = {
    description = "Creates djvu files from PDF files";
    homepage = http://0x2a.at/s/projects/djvu2pdf;
    license = stdenv.lib.licenses.gpl2;
    inherit version;
  };
}
