{
  fetchFromGitHub,
  lib,
  stdenv,
  SDL,
  SDL_image,
  SDL_mixer,
  SDL_sound,
  libsigcxx,
  physfs,
  boost,
  expat,
  freetype,
  libjpeg,
  wxGTK32,
  lua,
  perl,
  pkg-config,
  zlib,
  zip,
  bzip2,
  libpng,
  libtiff,
  fluidsynth,
  libmikmod,
  libvorbis,
  flac,
  libogg,
}:

stdenv.mkDerivation rec {
  pname = "asc";
  version = "2.6.3.0";

  src = fetchFromGitHub {
    owner = "ValHaris";
    repo = "asc-hq";
    rev = "fa3bca082a5cea2b35812349f99b877f0113aef0";
    sha256 = "atamYCN2mOqxV6auToTeWdpKuFfC+GLfLdRsfT0ouwQ=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    SDL
    SDL_image
    SDL_mixer
    SDL_sound
    physfs
    boost
    expat
    freetype
    libjpeg
    wxGTK32
    lua
    perl
    zlib
    zip
    bzip2
    libpng
    libtiff
    fluidsynth
    libmikmod
    flac
    libvorbis
    libogg
    libsigcxx
  ];

  meta = with lib; {
    description = "Turn based strategy game";

    longDescription = ''
      Advanced Strategic Command is a free, turn based strategy game. It is
      designed in the tradition of the Battle Isle series from Bluebyte and is
      currently available for Windows and Linux.
    '';

    homepage = "https://www.asc-hq.org/";

    license = licenses.gpl2Plus;

    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
  };
}
