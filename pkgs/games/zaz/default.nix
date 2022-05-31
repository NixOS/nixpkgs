{ lib, stdenv
, fetchurl
, pkg-config
, SDL
, SDL_image
, mesa
, libtheora
, libvorbis
, libogg
, ftgl
, freetype
}:

stdenv.mkDerivation rec {
  pname = "zaz";
  version = "1.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1r3bmwny05zzmdalxm5ah2rray0nnsg1w00r30p47q6x2lpwj8ml";
  };

  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [
    SDL.dev
    SDL_image
    mesa
    libtheora
    libvorbis.dev
    libogg
    ftgl
    freetype
  ];

  # Fix SDL include problems
  NIX_CFLAGS_COMPILE="-I${SDL.dev}/include/SDL -I${SDL_image}/include/SDL";
  # Fix linking errors
  makeFlags = [
    "ZAZ_LIBS+=-lSDL"
    "ZAZ_LIBS+=-lvorbis"
    "ZAZ_LIBS+=-ltheora"
    "ZAZ_LIBS+=-logg"
    "ZAZ_LIBS+=-ltheoraenc"
    "ZAZ_LIBS+=-ltheoradec"
    "ZAZ_LIBS+=-lvorbisfile"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A puzzle game about arranging balls in triplets, like Luxor, Zuma, or Puzzle Bobble";
    homepage = "http://zaz.sourceforge.net/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}

