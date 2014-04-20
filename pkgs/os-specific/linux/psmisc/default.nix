{stdenv, fetchurl, ncurses}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "psmisc-22.21";

  src = fetchurl {
    url = "mirror://sourceforge/psmisc/${name}.tar.gz";
    sha256 = "0nhlm1vrrwn4a845p6y4nnnb4liq70n74zbdd5dq844jc6nkqclp";
  };

  buildInputs = [ncurses];

  meta = {
    homepage = http://psmisc.sourceforge.net/;
    description = "A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)";
    platforms = stdenv.lib.platforms.linux;
  };
}
