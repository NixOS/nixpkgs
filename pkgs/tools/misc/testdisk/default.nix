{ stdenv, fetchurl, ncurses, libjpeg, e2fsprogs, zlib, openssl, libuuid, ntfs3g }:

stdenv.mkDerivation {
  name = "testdisk-7.0";

  src = fetchurl {
    url = http://www.cgsecurity.org/testdisk-7.0.tar.bz2;
    sha256 = "00bb3b6b22e6aba88580eeb887037aef026968c21a87b5f906c6652cbee3442d";
  };

  buildInputs = [ ncurses libjpeg zlib openssl libuuid ]
    ++ stdenv.lib.optionals (!stdenv.isDarwin) [ e2fsprogs ntfs3g ];

  enableParallelBuilding = true;

  meta = {
    homepage = http://www.cgsecurity.org/wiki/TestDisk;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    longDescription = ''
      TestDisk is a program for data recovery, primarily designed to
      help recover lost partitions and/or make non-booting disks
      bootable again.
    '';
  };
}
