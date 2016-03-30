{ fetchurl, stdenv, ncurses, curl, pkgconfig, gnutls, readline, openssl, perl, libjpeg
, libzrtpcpp }:

stdenv.mkDerivation rec {
  name = "freeswitch-1.6.6";

  src = fetchurl {
    url = "http://files.freeswitch.org/releases/freeswitch/${name}.tar.bz2";
    sha256 = "0kfvn5f75c6r6yp18almjz9p6llvpm66gpbxcjswrg3ddgbkzg0k";
  };

  buildInputs = [ ncurses curl pkgconfig gnutls readline openssl perl libjpeg
    libzrtpcpp ];

  NIX_CFLAGS_COMPILE = "-Wno-error";

  hardeningDisable = [ "format" ];

  meta = {
    description = "Cross-Platform Scalable FREE Multi-Protocol Soft Switch";
    homepage = http://freeswitch.org/;
    license = stdenv.lib.licenses.mpl11;
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
