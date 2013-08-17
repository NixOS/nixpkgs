{ stdenv, fetchurl, pkgconfig, glib }:

stdenv.mkDerivation rec {
  name = "mpack-1.6";

  src = fetchurl {
    url = "http://ftp.andrew.cmu.edu/pub/mpack/${name}.tar.gz";
    sha256 = "0k590z96509k96zxmhv72gkwhrlf55jkmyqlzi72m61r7axhhh97";
  };

  patches = [ ./build-fix.patch ];

  preConfigure = "configureFlags=--mandir=$out/share/man";

  meta = {
    description = "utilities for encoding and decoding binary files in MIME";
    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.unix;
  };
}
