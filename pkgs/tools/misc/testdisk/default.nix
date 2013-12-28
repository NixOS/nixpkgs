{stdenv, fetchurl, ncurses, libjpeg, e2fsprogs, zlib, openssl, libuuid}:

stdenv.mkDerivation {
  name = "testdisk-6.14";

  src = fetchurl {
    url = http://www.cgsecurity.org/testdisk-6.14.tar.bz2;
    sha256 = "0v1jap83f5h99zv01v3qmqm160d36n4ysi0gyq7xzb3mqgmw75x5";
  };

  buildInputs = [ncurses libjpeg e2fsprogs zlib openssl libuuid];

  meta = {
    homepage = http://www.cgsecurity.org/wiki/TestDisk;
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    longDescription = ''
      TestDisk is a program for data recovery, primarily designed to
      help recover lost partitions and/or make non-booting disks
      bootable again.
    '';
  };
}
