{ stdenv, fetchurl, udev, pkgconfig, dbus_libs }:

stdenv.mkDerivation rec {
  name = "pcsclite-1.7.4";

  src = fetchurl {
    url = "http://alioth.debian.org/frs/download.php/3598/${name}.tar.bz2";
    sha256 = "1lc3amxisv2ya51v0gysygldj25kv7zj81famv69s205mvmagr6q";
  };

  # The OS should care on preparing the drivers into this location
  configureFlags = [ "--enable-usbdropdir=/var/lib/pcsc/drivers" ];

  preConfigure = ''
    configureFlags="$configureFlags --enable-confdir=$out/etc"
  '';

  buildInputs = [ udev dbus_libs ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Middleware to access a smart card using SCard API (PC/SC)";
    homepage = http://pcsclite.alioth.debian.org/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
