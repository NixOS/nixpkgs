{stdenv, fetchurl, ncurses}:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "psmisc-23.0";

  src = fetchurl {
    url = "mirror://sourceforge/psmisc/${name}.tar.xz";
    sha256 = "0k7hafh9388s3hh9j943jy1qk9g1c43j02nyk0xis0ngbs632lvm";
  };

  buildInputs = [ncurses];

  meta = {
    homepage = http://psmisc.sourceforge.net/;
    description = "A set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)";
    platforms = stdenv.lib.platforms.linux;
  };
}
