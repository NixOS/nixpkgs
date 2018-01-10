{ stdenv, fetchFromGitHub, cmake, doxygen ? null, pkgconfig, freetype ? null, harfbuzz ? null
, liblcf, libpng, libsndfile ? null, libxmp ? null, libvorbis ? null, mpg123 ? null
, opusfile ? null, pixman, SDL2, speexdsp ? null, wildmidi ? null, zlib }:

stdenv.mkDerivation rec {
  name = "easyrpg-player-${version}";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "Player";
    rev = version;
    sha256 = "1cn3g08ap6cf812s8p3ilf31q7y7y4knp1s0gk45mqcz215cpd8q";
  };

  nativeBuildInputs = [ cmake doxygen pkgconfig ];

  buildInputs = [
    freetype
    harfbuzz
    liblcf
    libpng
    libsndfile
    libxmp
    libvorbis
    mpg123
    opusfile
    SDL2
    pixman
    speexdsp
    wildmidi
    zlib
  ];

  meta = with stdenv.lib; {
    homepage = https://easyrpg.org/;
    license = licenses.gpl3;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = platforms.linux;
  };
}
