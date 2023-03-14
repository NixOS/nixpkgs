{ lib, stdenv, fetchFromGitHub, cmake, doxygen ? null, pkg-config
, freetype ? null, fmt, glib, harfbuzz ? null
, liblcf, libpng, libsndfile ? null, libvorbis ? null, libxmp ? null
, libXcursor, libXext, libXi, libXinerama, libXrandr, libXScrnSaver, libXxf86vm
, mpg123 ? null, opusfile ? null, pcre, pixman, SDL2, speexdsp ? null, wildmidi ? null, zlib
, libdecor
}:

stdenv.mkDerivation rec {
  pname = "easyrpg-player";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "Player";
    rev = version;
    sha256 = "049bj3jg3ldi3n11nx8xvh6pll68g7dcxz51q6z1gyyfxxws1qpj";
  };

  nativeBuildInputs = [ cmake doxygen pkg-config ];

  buildInputs = [
    fmt
    freetype
    glib
    harfbuzz
    liblcf
    libpng
    libsndfile
    libvorbis
    libxmp
    libXcursor
    libXext
    libXi
    libXinerama
    libXrandr
    libXScrnSaver
    libXxf86vm
    mpg123
    opusfile
    pcre
    pixman
    SDL2
    speexdsp
    wildmidi
    zlib
    libdecor
  ];

  meta = with lib; {
    description = "RPG Maker 2000/2003 and EasyRPG games interpreter";
    homepage = "https://easyrpg.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ yana ];
    platforms = platforms.linux;
  };
}
