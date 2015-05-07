{ stdenv, fetchurl, openssl, avahi, alsaLib, libdaemon, autoconf, automake, libtool, popt, unzip, pkgconfig, libconfig, pulseaudio }:

stdenv.mkDerivation rec {
  version = "2.3.0";
  name = "shairport-sync-${version}";

  src = fetchurl {
    url = "https://github.com/mikebrady/shairport-sync/archive/${version}.zip";
    sha256 = "1kslif2ifrn0frvi39d44wpn53sjahwq0xjc0hd98ycf3xbcgndg";
  };

  buildInputs = [
    openssl
    avahi
    alsaLib
    libdaemon
    autoconf
    automake
    pkgconfig
    libtool
    popt
    unzip
    libconfig
    pulseaudio
  ];

  enableParallelBuilding = true;

  preConfigure = "autoreconf -vfi";
  configureFlags = "--with-alsa --with-avahi --with-ssl=openssl --without-initscript --with-pulseaudio";

  meta = with stdenv.lib; {
    homepage = https://github.com/mikebrady/shairport-sync;
    description = "Airtunes server and emulator with multi-room capabilities";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
