{ stdenv, fetchurl, ncurses, libjpeg, e2fsprogs, zlib, openssl, libuuid, ntfs3g }:

stdenv.mkDerivation {
  name = "testdisk-7.1";

  src = fetchurl {
    url = https://www.cgsecurity.org/testdisk-7.0.tar.bz2;
    sha256 = "0ba4wfz2qrf60vwvb1qsq9l6j0pgg81qgf7fh22siaz649mkpfq0";
  };

  buildInputs = [ ncurses libjpeg zlib openssl libuuid ]
    ++ stdenv.lib.optionals (!stdenv.isDarwin) [ e2fsprogs ntfs3g ];

  enableParallelBuilding = true;

  meta = {
    homepage = https://www.cgsecurity.org/wiki/TestDisk;
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
