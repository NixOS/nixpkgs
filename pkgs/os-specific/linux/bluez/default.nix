{ stdenv, fetchurl, pkgconfig, dbus, glib, libusb, alsaLib }:

assert stdenv.isLinux;
   
stdenv.mkDerivation rec {
  name = "bluez-4.69";
   
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.gz";
    sha256 = "1h4fp6l1sflc0l5vg90hzvgldlwv7rqc4cbn2z6axmxv969pmrhh";
  };

  buildInputs = [ pkgconfig dbus.libs glib libusb alsaLib ];

  configureFlags = "--localstatedir=/var";

  # Work around `make install' trying to create /var/lib/bluetooth.
  installFlags = "statedir=$(TMPDIR)/var/lib/bluetooth";

  meta = {
    homepage = http://www.bluez.org/;
    description = "Bluetooth support for Linux";
  };
}
