{ lib
, stdenv
, fetchurl
, SDL
, SDL_mixer
, libintl
, libpng
, zlib
}:

stdenv.mkDerivation rec {
  pname = "lbreakout2";
  version = "2.6.5";

  src = fetchurl {
    url = "mirror://sourceforge/lgames/${pname}-${version}.tar.gz";
    sha256 = "0vwdlyvh7c4y80q5vp7fyfpzbqk9lq3w8pvavi139njkalbxc14i";
  };

  buildInputs = [
    SDL
    SDL_mixer
    libintl
    libpng
    zlib
  ];

  meta = with lib; {
    homepage = "http://lgames.sourceforge.net/LBreakout2/";
    description = "Breakout clone from the LGames series";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.ciil ];
    platforms = platforms.unix;
    hydraPlatforms = lib.platforms.linux; # sdl-config times out on darwin
  };
}
