{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  name = "psmisc-22.7";
  
  src = fetchurl {
    url = "mirror://sourceforge/psmisc/${name}.tar.gz";
    sha256 = "1b8xs4sqf8wljbxn7y1nqdf8mgbn0d2yip93jbz8lyak6d68g704";
  };
  
  buildInputs = [ncurses];

  meta = {
    homepage = http://psmisc.sourceforge.net/;
    description = "A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)";
    platforms = stdenv.lib.platforms.linux;    
  };
}
