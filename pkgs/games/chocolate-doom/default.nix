{ stdenv, autoreconfHook, pkgconfig, SDL, SDL_mixer, SDL_net, fetchurl }:

stdenv.mkDerivation rec {
  name = "chocolate-doom-2.3.0";
  src = fetchurl {
    url = "https://github.com/chocolate-doom/chocolate-doom/archive/${name}.tar.gz";
    sha256 = "0i57smxmbhxj0wgvxq845ba9zsn5nx5wmzkl71rdchyd4q5jmida";
  };
  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ SDL SDL_mixer SDL_net ];
  patchPhase = ''
    sed -e 's#/games#/bin#g' -i src{,/setup}/Makefile.am
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://chocolate-doom.org/;
    description = "A Doom source port that accurately reproduces the experience of Doom as it was played in the 1990s";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.unix;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
