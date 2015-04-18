{ stdenv, fetchurl, pkgconfig, udev, dbus_libs, perl }:

stdenv.mkDerivation rec {
  name = "pcsclite-1.8.13";

  src = fetchurl {
    url = "https://alioth.debian.org/frs/download.php/file/4126/pcsc-lite-1.8.13.tar.bz2";
    sha256 = "0fxwzckbjsckfp1f01yp3x6y1wlaaivhy12a5hka6qwdh1z085gk";
  };

  # The OS should care on preparing the drivers into this location
  configureFlags = [
    "--enable-usbdropdir=/var/lib/pcsc/drivers"
    "--with-systemdsystemunitdir=$out/etc/systemd/system"
    "--enable-confdir=$out/etc"
  ];

  buildInputs = [ udev dbus_libs perl ];

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "Middleware to access a smart card using SCard API (PC/SC)";
    homepage = http://pcsclite.alioth.debian.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ viric wkennington ];
    platforms = with platforms; linux;
  };
}
