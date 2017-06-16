{ stdenv, fetchurl, SDL, SDL_mixer }:

stdenv.mkDerivation rec {
  name = "ltris-${version}";
  version = "1.0.19";
  buildInputs = [ SDL SDL_mixer ];

  src = fetchurl {
    url = "mirror://sourceforge/lgames/${name}.tar.gz";
    sha256 = "1895wv1fqklrj4apkz47rnkcfhfav7zjknskw6p0886j35vrwslg";
  };

  patchPhase = "patch -p0 < ${./gcc5_compliance.diff}";

  meta = with stdenv.lib; {
    description = "Tetris clone from the LGames series";
    homepage = http://lgames.sourceforge.net/LBreakout2/;
    license = licenses.gpl2;
    maintainers = [ maintainers.ciil ];
    platforms = platforms.linux;
  };
}
