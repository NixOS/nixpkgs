{ stdenv, autoconf, automake, pkgconfig, SDL, SDL_mixer, SDL_net, git, fetchgit }:

stdenv.mkDerivation rec {
  name = "chocolate-doom-20141008";
  src = fetchgit {
    url = git://github.com/fragglet/chocolate-doom.git;
    rev = "63e1c884911f9e3382936f84a388e941b29343e6";
    sha256 = "1855a70widf1ni7lrfvp3hwxs1fhg1v5l738ckai88xpbak8i14m";
  };
  buildInputs = [ autoconf automake pkgconfig SDL SDL_mixer SDL_net git ];
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
