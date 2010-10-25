{stdenv, fetchurl, ncurses}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "psmisc-22.13";

  src = fetchurl {
    url = "mirror://sourceforge/psmisc/${name}.tar.gz";
    sha256 = "06d25e8ebb4722dbcede98a787c39a9ed341f8e58fde10c0b2d6b35990b35daa";
  };

  buildInputs = [ncurses];

  meta = {
    homepage = http://psmisc.sourceforge.net/;
    description = "A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)";
    platforms = stdenv.lib.platforms.linux;
  };
}
