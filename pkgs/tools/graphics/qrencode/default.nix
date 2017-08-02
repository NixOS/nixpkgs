{ stdenv, fetchurl, libpng, pkgconfig }:

stdenv.mkDerivation rec {
  name = "qrencode-3.4.4";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.bz2";
    sha256 = "198zvsfa2y5bb3ccikrhmhd4i43apr3b26dqcf3zkjyv3n5iirgg";
  };

  buildInputs = [ libpng ];
  nativeBuildInputs = [ pkgconfig ];

  meta = {
    homepage = https://fukuchi.org/works/qrencode/;
    description = "QR code encoder";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
