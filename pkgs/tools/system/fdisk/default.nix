{ fetchurl, stdenv, parted, libuuid, gettext }:

stdenv.mkDerivation rec {
  name = "fdisk-1.3.0a";

  src = fetchurl {
    url = "mirror://gnu/fdisk/${name}.tar.bz2";
    sha256 = "1g2zvl560f7p1hd4q50d1msy6qp7949mdkagfy8ki8cayp8fp267";
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
