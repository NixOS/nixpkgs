{ stdenv, fetchurl, pkgconfig, udev, dbus_libs, perl }:

stdenv.mkDerivation rec {
  name = "pcsclite-1.8.14";

  src = fetchurl {
    url = "https://alioth.debian.org/frs/download.php/file/4138/pcsc-lite-1.8.14.tar.bz2";
    sha256 = "0kik09dif6hih09vvprd7zvj31lnrclrbrh5y10mlca2c209f7xr";
  };

  configureFlags = [
    # The OS should care on preparing the drivers into this location
    "--enable-usbdropdir=/var/lib/pcsc/drivers"
    "--with-systemdsystemunitdir=\${out}/etc/systemd/system"
    "--enable-confdir=/etc"
  ];

  nativeBuildInputs = [ pkgconfig perl ];
  buildInputs = [ udev dbus_libs ];

  meta = with stdenv.lib; {
    description = "Middleware to access a smart card using SCard API (PC/SC)";
    homepage = http://pcsclite.alioth.debian.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ viric wkennington ];
    platforms = with platforms; linux;
  };
}
