{ fetchurl, stdenv, ncurses, curl, pkgconfig, gnutls, readline, openssl, perl, libjpeg }:

stdenv.mkDerivation rec {
  name = "freeswitch-1.0.7";

  src = fetchurl {
    url = http://latest.freeswitch.org/freeswitch-1.0.7.tar.gz;
    sha256 = "0r7mqsc50y7aqm8arbwiq75ikwfrrfhhzdf9r070snrf3b8qkj8w";
  };

  buildInputs = [ ncurses curl pkgconfig gnutls readline openssl perl libjpeg ];

  meta = {
    description = "Cross-Platform Scalable FREE Multi-Protocol Soft Switch";
    homepage = http://freeswitch.org/;
    license = "MPL1.1";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
