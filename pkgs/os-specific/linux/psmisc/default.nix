{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  name = "psmisc-22.12";
  
  src = fetchurl {
    url = "mirror://sourceforge/psmisc/${name}.tar.gz";
    sha256 = "0ykak6gf835xj0wksqbw2rjny958prayhm2fv6r3fqfs06jl2bxs";
  };
  
  buildInputs = [ncurses];

  meta = {
    homepage = http://psmisc.sourceforge.net/;
    description = "A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)";
    platforms = stdenv.lib.platforms.linux;
  };
}
