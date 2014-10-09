{ stdenv, fetchurl, pkgconfig, udev, dbus_libs, perl }:

stdenv.mkDerivation rec {
  version = "1.8.12";
  name = "pcsclite-${version}";

  src = fetchurl {
    url = "https://alioth.debian.org/frs/download.php/file/3991/pcsc-lite-${version}.tar.bz2";
    sha256 = "1ihsqyiygkyhid739zcvaizyd7q9qm76lqb7lzjrm5ak9k4l2l4l";
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
