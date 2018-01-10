{ stdenv, fetchurl, libpng, pkgconfig }:

stdenv.mkDerivation rec {
  name = "qrencode-4.0.0";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.bz2";
    sha256 = "02vx69fl52jbcrmnydsaxcmy6nxqm9jyxzd7hr07s491d7hka069";
  };

  buildInputs = [ libpng ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    homepage = https://fukuchi.org/works/qrencode/;
    description = "QR code encoder";
    platforms = platforms.all;
    maintainers = with maintainers; [ yegortimoshenko ];
  };
}
