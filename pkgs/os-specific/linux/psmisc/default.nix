{stdenv, fetchurl, ncurses}:

stdenv.mkDerivation rec {
  name = "psmisc-23.1";

  src = fetchurl {
    url = "mirror://sourceforge/psmisc/${name}.tar.xz";
    sha256 = "0c5s94hqpwfmyswx2f96gifa6wdbpxxpkyxcrlzbxpvmrxsd911f";
  };

  buildInputs = [ncurses];

  meta = {
    homepage = http://psmisc.sourceforge.net/;
    description = "A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
