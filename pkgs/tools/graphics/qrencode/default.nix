{ stdenv, fetchurl, libpng, pkgconfig }:

stdenv.mkDerivation rec {
  name = "qrencode-4.0.2";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.bz2";
    sha256 = "1d2q5d3v8g3hsi3h5jq4n177bjhf3kawms09immw7p187f6jgjy9";
  };

  buildInputs = [ libpng ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    homepage = https://fukuchi.org/works/qrencode/;
    description = "QR code encoder";
    platforms = platforms.all;
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ yegortimoshenko ];
  };
}
