{stdenv, fetchurl, e2fsprogs, readline}:

stdenv.mkDerivation {
  name = "parted-1.8.8";
  src = fetchurl {
    url = mirror://gnu/parted/parted-1.8.8.tar.bz2;
    sha256 = "1sn5qcdi4pvxnxz8ryh5p52qmqd72qbk0d0a65pksxf7khd83kfz";
  };
  buildInputs = [e2fsprogs readline];

  preConfigure=''
    export CFLAGS=-fgnu89-inline
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -fgnu89-inline"
  '';
  configureFlags = "--without-readline";

  meta = {
    description = "industrial-strength package for creating, destroying, resizing, checking and copying partitions";
    homepage = http://www.gnu.org/software/parted/;
    license = "GPLv3";
  };
}
