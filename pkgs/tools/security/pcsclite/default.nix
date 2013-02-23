{ stdenv, fetchurl, pkgconfig, udev, dbus_libs, perl }:

stdenv.mkDerivation rec {
  name = "pcsclite-1.8.8";

  src = fetchurl {
    url = "http://alioth.debian.org/frs/download.php/3862/${name}.tar.bz2";
    sha256 = "1rw5530vr2jf02ziyf32jbd98n5q8zjcfwp5nkw3x3bkgr53arpy";
  };

  # The OS should care on preparing the drivers into this location
  configureFlags = [
    "--enable-usbdropdir=/var/lib/pcsc/drivers"
    "--with-systemdsystemunitdir=$out/lib/systemd/system" # probably
  ];

  preConfigure = ''
    configureFlags="$configureFlags --enable-confdir=$out/etc"
  '';

  buildInputs = [ udev dbus_libs perl ];

  nativeBuildInputs = [ pkgconfig ];

  meta = {
    description = "Middleware to access a smart card using SCard API (PC/SC)";
    homepage = http://pcsclite.alioth.debian.org/;
    license = "BSD";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
