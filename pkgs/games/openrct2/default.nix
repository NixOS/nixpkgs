{ stdenv, fetchFromGitHub, cmake, pkgconfig, libpng, jansson, curl
, SDL2, SDL2_ttf, speexdsp, expat }:

stdenv.mkDerivation rec {
  name = "openrct2-${version}";
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "OpenRCT2";
    repo = "OpenRCT2";
    rev = "v${version}";
    sha256 = "0w1rr082z8n7i5q6fmv1r8dkisl28gzk2jilick02mkkryvfw12h";
  };

  nativeBuildInputs = [ pkgconfig cmake ];
  buildInputs = [ libpng jansson SDL2 SDL2_ttf curl speexdsp expat ];

  meta = with stdenv.lib; {
    description = "";
    homepage = https://openrct2.org/;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
