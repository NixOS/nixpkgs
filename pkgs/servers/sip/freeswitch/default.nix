{ fetchgit, stdenv, ncurses, curl, pkgconfig, gnutls, readline, openssl, perl, libjpeg
, libzrtpcpp, autoconf, automake, libtool }:

stdenv.mkDerivation rec {
  name = "freeswitch-git-0db52e6";

  src = fetchgit {
    url = "git://git.freeswitch.org/freeswitch.git";
    rev = "0db52e6e556fce584f1850c3a3b87c8f46ff87c5";
    sha256 = "5cc7161c1ba64c5faf3dda2669e9aafd529eaa66be2fd83f284304444bcab9ff";
  };

  preConfigure = ''
    ./bootstrap.sh
  '';

  buildInputs = [ ncurses curl pkgconfig gnutls readline openssl perl libjpeg
    autoconf automake libtool libzrtpcpp ];

  meta = {
    description = "Cross-Platform Scalable FREE Multi-Protocol Soft Switch";
    homepage = http://freeswitch.org/;
    license = "MPL1.1";
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
