{stdenv, fetchurl, ncurses}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "psmisc-22.21";

  src = fetchurl {
    url = "mirror://sourceforge/psmisc/${name}.tar.gz";
    sha256 = "1p13s2323mi2868y4fzy3q2kkmv4fn1ggabqnjf202x4030vjj1q";
  };

  buildInputs = [ncurses];

  meta = {
    homepage = http://psmisc.sourceforge.net/;
    description = "A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)";
    platforms = stdenv.lib.platforms.linux;
  };
}
