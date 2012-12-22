{ fetchurl, stdenv, ncurses, curl, pkgconfig, gnutls, readline, openssl, perl, libjpeg
, libzrtpcpp }:

stdenv.mkDerivation rec {
  name = "freeswitch-1.2.3";

  src = fetchurl {
    url = http://files.freeswitch.org/freeswitch-1.2.3.tar.bz2;
    sha256 = "0kfvn5f75c6r6yp18almjz9p6llvpm66gpbxcjswrg3ddgbkzg0k";
  };

  buildInputs = [ ncurses curl pkgconfig gnutls readline openssl perl libjpeg
    libzrtpcpp ];

  meta = {
    description = "Cross-Platform Scalable FREE Multi-Protocol Soft Switch";
    homepage = http://freeswitch.org/;
    license = "MPL1.1";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
