{ stdenv
, fetchurl
, pkgconfig
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
  version = "1.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.bz2";
    sha256 = "15q3kxzl71m50byw37dshfsx5wp240ywah19ccmqmqarcldcqcp3";
  };

  nativeBuildInputs = [
    pkgconfig
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

  meta = with stdenv.lib; {
    description = "A puzzle game about arranging balls in triplets, like Luxor, Zuma, or Puzzle Bobble";
    homepage = "http://zaz.sourceforge.net/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}

