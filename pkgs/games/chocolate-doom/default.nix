{ stdenv, autoconf, automake, pkgconfig, SDL, SDL_mixer, SDL_net, fetchurl }:

stdenv.mkDerivation rec {
  name = "chocolate-doom-2.0.0";
  src = fetchurl {
    url = https://github.com/chocolate-doom/chocolate-doom/archive/chocolate-doom-2.0.0.tar.gz;
    sha256 = "1n9lkx97h987bq8z586jgissdhs07xyfr0xfdk7m2wpw4yhw10k1";
  };
  buildInputs = [ autoconf autoconf automake pkgconfig SDL SDL_mixer SDL_net ];
  patchPhase = ''
    sed -e 's#/games#/bin#g' -i src{,/setup}/Makefile.am
    ./autogen.sh --prefix=$out
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = http://chocolate-doom.org/;
    description = "A Doom source port that accurately reproduces the experience of Doom as it was played in the 1990s";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ MP2E ];
  };
}
