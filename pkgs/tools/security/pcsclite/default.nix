{ stdenv, fetchurl, pkgconfig, udev, dbus_libs, perl }:

stdenv.mkDerivation rec {
  version = "1.8.10";
  name = "pcsclite-${version}";

  src = fetchurl {
    url = "http://ftp.de.debian.org/debian/pool/main/p/pcsc-lite/pcsc-lite_${version}.orig.tar.bz2";
    sha256 = "04i63zi9ayg38z3cahp6gf3rgx23w17bmcpdccm2hvaj63blnz30";
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
