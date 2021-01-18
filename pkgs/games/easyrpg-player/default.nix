{ lib, stdenv, fetchFromGitHub, cmake, doxygen ? null, pkg-config, freetype ? null, glib, harfbuzz ? null
, liblcf, libpng, libsndfile ? null, libvorbis ? null, libxmp ? null
, libXcursor, libXext, libXi, libXinerama, libXrandr, libXScrnSaver, libXxf86vm
, mpg123 ? null, opusfile ? null, pcre, pixman, SDL2_mixer, speexdsp ? null, wildmidi ? null, zlib }:

stdenv.mkDerivation rec {
  pname = "easyrpg-player";
  version = "0.6.2.3";

  src = fetchFromGitHub {
    owner = "EasyRPG";
    repo = "Player";
    rev = version;
    sha256 = "103ywad12dcfjpf97kyx22smilqrw1f20xcfvjjr4mm3walc2mdp";
  };

  nativeBuildInputs = [ cmake doxygen pkg-config ];

  buildInputs = [
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
    SDL2_mixer
    pcre
    pixman
    speexdsp
    wildmidi
    zlib
  ];

  meta = with lib; {
    description = "RPG Maker 2000/2003 and EasyRPG games interpreter";
    homepage = "https://easyrpg.org/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = platforms.linux;
  };
}
