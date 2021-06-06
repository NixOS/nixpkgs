{ fetchurl, lib, stdenv, parted, libuuid, gettext, guile }:

stdenv.mkDerivation rec {
  name = "gnufdisk-2.0.0a"; # .0a1 seems broken, see https://lists.gnu.org/archive/html/bug-fdisk/2012-09/msg00000.html

  src = fetchurl {
    url = "mirror://gnu/fdisk/${name}.tar.gz";
    sha256 = "04nd7civ561x2lwcmxhsqbprml3178jfc58fy1v7hzqg5k4nbhy3";
  };

  buildInputs = [ parted libuuid gettext guile ];

  doCheck = true;

  meta = {
    description = "A command-line disk partitioning tool";

    longDescription = ''
      GNU fdisk provides alternatives to util-linux fdisk and util-linux
      cfdisk.  It uses GNU Parted.
    '';

    license = lib.licenses.gpl3Plus;

    homepage = "https://www.gnu.org/software/fdisk/";

    platforms = lib.platforms.linux;
  };
}
