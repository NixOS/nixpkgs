{ stdenv, fetchurl, SDL, SDL_mixer, zlib, libpng, libintl }:

stdenv.mkDerivation rec {
  name = "lbreakout2-${version}";
  version = "2.6.5";
  buildInputs = [ SDL SDL_mixer zlib libpng libintl ];

  src = fetchurl {
    url = "mirror://sourceforge/lgames/${name}.tar.gz";
    sha256 = "0vwdlyvh7c4y80q5vp7fyfpzbqk9lq3w8pvavi139njkalbxc14i";
  };

  meta = with stdenv.lib; {
    description = "Breakout clone from the LGames series";
    homepage = http://lgames.sourceforge.net/LBreakout2/;
    license = licenses.gpl2;
    maintainers = [ maintainers.ciil ];
    platforms = platforms.unix;
  };
}
