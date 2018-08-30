{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  name = "psmisc-23.2";

  src = fetchurl {
    url = "mirror://sourceforge/psmisc/${name}.tar.xz";
    sha256 = "0s1kjhrik0wzqbm7hv4gkhywhjrwhp9ajw0ad05fwharikk6ah49";
  };

  buildInputs = [ncurses];

  meta = {
    homepage = http://psmisc.sourceforge.net/;
    description = "A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
