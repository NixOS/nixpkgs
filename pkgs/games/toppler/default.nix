{ lib, stdenv
, fetchurl
, SDL
, SDL_mixer
, zlib
}:

stdenv.mkDerivation rec {
  pname = "toppler";
  version = "1.1.6";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.gz";
    sha256 = "0ifccissd8sh78kpwh7dafx4ah7hkhqz6nf4z2hdnalw702jkg3x";
  };

  buildInputs = [
    SDL
    SDL_mixer
    zlib
  ];

  # The conftest hangs on Hydra runners, because they are not logged in.
  configureFlags = lib.optional stdenv.isDarwin "--disable-sdltest";

  meta = with lib; {
    description = "Jump and run game, reimplementation of Tower Toppler/Nebulus";
    homepage = "http://toppler.sourceforge.net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.all;
  };
}

