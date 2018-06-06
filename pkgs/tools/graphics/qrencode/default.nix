{ stdenv, fetchurl, libpng, pkgconfig }:

stdenv.mkDerivation rec {
  name = "qrencode-4.0.1";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.bz2";
    sha256 = "0j7cqhjc0l6i99lzph51gakmcmfs74x483plna93r4ngz328knph";
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
