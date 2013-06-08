{stdenv, fetchurl, ncurses, libjpeg, e2fsprogs, zlib, openssl, libuuid}:

stdenv.mkDerivation {
  name = "testdisk-6.13";
  
  src = fetchurl {
    url = http://www.cgsecurity.org/testdisk-6.13.tar.bz2;
    sha256 = "087jrn41z3ymf1b6njl2bg99pr79v8l1f63f7rn5ni69vz6mq9s8";
  };

  buildInputs = [ncurses libjpeg e2fsprogs zlib openssl libuuid];

  meta = {
    homepage = http://www.cgsecurity.org/wiki/TestDisk;
    license = "GPLv2+";
    longDescription = ''
      TestDisk is a program for data recovery, primarily designed to
      help recover lost partitions and/or make non-booting disks
      bootable again.
    '';
  };
}
