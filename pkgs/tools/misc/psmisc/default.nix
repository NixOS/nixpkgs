{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation {
  name = "psmisc-22.6";
  src = fetchurl {
    url = mirror://sourceforge/psmisc/psmisc-22.6.tar.gz;
    sha256 = "0qlx4rdcj3igk67gzmdbyy6f54h4c5ya17gw0pkxdcwlgj4q2g51";
  };
  buildInputs = [ncurses];

  meta = {
    homepage = http://psmisc.sourceforge.net/;
    description = "A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)";
  };
}
