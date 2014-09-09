{ stdenv, autoconf, automake, pkgconfig, SDL, SDL_mixer, SDL_net, git, fetchgit }:

stdenv.mkDerivation rec {
  name = "chocolate-doom-20140902";
  src = fetchgit {
    url = git://github.com/fragglet/chocolate-doom.git;
    rev = "204814c7bb16a8ad45435a15328072681978ea57";
    sha256 = "1xcdxpkgb9dk3zwqf4xcr3qn7dh5rx6hmniky67imbvi1h74p587";
  };
  buildInputs = [ autoconf autoconf automake pkgconfig SDL SDL_mixer SDL_net git ];
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
