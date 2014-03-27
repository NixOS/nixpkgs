{ stdenv, fetchurl, pkgconfig, udev, dbus_libs, perl }:

stdenv.mkDerivation rec {
  version = "1.8.10";
  name = "pcsclite-${version}";

  src = fetchurl {
    url = "https://alioth.debian.org/frs/download.php/file/3963/pcsc-lite-${version}.tar.bz2";
    sha256 = "04i63zi9ayg38z3cahp6gf3rgx23w17bmcpdccm2hvaj63blnz30";
  };

  # The OS should care on preparing the drivers into this location
  configureFlags = [
    "--enable-usbdropdir=/var/lib/pcsc/drivers"
    "--with-systemdsystemunitdir=$out/etc/systemd/system"
    "--enable-confdir=$out/etc"
  ];

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
