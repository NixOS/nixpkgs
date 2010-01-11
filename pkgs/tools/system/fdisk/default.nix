{ fetchurl, stdenv, parted, libuuid, gettext }:

stdenv.mkDerivation rec {
  name = "fdisk-1.2.4";

  src = fetchurl {
    url = "mirror://gnu/fdisk/${name}.tar.bz2";
    sha256 = "17xl8xa1cwaxcdw49m1kqwralhac2y2z8nbx7mwlf28dpplvd9p0";
  };

  buildInputs = [ parted libuuid gettext ];

  doCheck = true;

  meta = {
    description = "GNU fdisk, a command-line disk partitioning tool";

    longDescription = ''
      GNU fdisk provides alternatives to util-linux fdisk and util-linux
      cfdisk.  It uses GNU Parted.
    '';

    license = "GPLv3+";

    homepage = http://www.gnu.org/software/fdisk/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.linux;
  };
}
