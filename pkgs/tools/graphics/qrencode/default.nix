{ stdenv, fetchurl, libpng, pkgconfig }:

stdenv.mkDerivation rec {
  name = "qrencode-3.2.0";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.bz2";
    sha256 = "13q6cz2lif8d7y95f8sgfqaxc1qr0sz9nl2xh71lfmx7v5ybri03";
  };

  buildInputs = [ libpng ];
  buildNativeInputs = [ pkgconfig ];

  meta = {
    homepage = http://fukuchi.org/works/qrencode/;
    description = "QR code encoder";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
