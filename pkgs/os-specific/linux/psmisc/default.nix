{stdenv, fetchurl, ncurses}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "psmisc-22.19";

  src = fetchurl {
    url = "mirror://sourceforge/psmisc/${name}.tar.gz";
    sha256 = "e112ccadd4694c98f5ea4a02cd6944fdc5a2a1985f20e2b3f74f4dbca83a2a31";
  };

  buildInputs = [ncurses];

  meta = {
    homepage = http://psmisc.sourceforge.net/;
    description = "A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)";
    platforms = stdenv.lib.platforms.linux;
  };
}
