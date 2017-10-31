{ stdenv, fetchurl, pkgconfig, fuse, libmtp, glib, libmad, libid3tag }:

stdenv.mkDerivation rec {
  name = "mtpfs-1.1";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ fuse libmtp glib libid3tag libmad ];

  # adding LIBS is a hack, duno why it does not find libid3tag.so by adding buildInputs
  preConfigure = ''
    export MAD_CFLAGS=${libmad}/include
    export MAD_LIBS=${libmad}/lib/libmad.so
    export LIBS=${libid3tag}/lib/libid3tag.so
  '';

  src = fetchurl {
    url = "http://www.adebenham.com/files/mtp/${name}.tar.gz";
    sha256 = "07acrqb17kpif2xcsqfqh5j4axvsa4rnh6xwnpqab5b9w5ykbbqv";
  };

  meta = {
    homepage = https://code.google.com/p/mtpfs/;
    description = "FUSE Filesystem providing access to MTP devices";
    platforms = stdenv.lib.platforms.all;
    maintainers = [ stdenv.lib.maintainers.qknight ];
  };
}
