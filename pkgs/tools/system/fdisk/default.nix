{ fetchurl, stdenv, parted, libuuid, gettext }:

stdenv.mkDerivation rec {
  name = "fdisk-1.2.3";

  src = fetchurl {
    url = "mirror://gnu/fdisk/${name}.tar.bz2";
    sha256 = "04nsa0xf1m5zy45wqv88ksk3xxc86r9n8f4mj3r6gm7rz0sfiqil";
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
