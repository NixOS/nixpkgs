{ stdenv, fetchurl, pkgconfig, dbus, glib, libusb, alsaLib }:

assert stdenv.isLinux;
   
stdenv.mkDerivation rec {
  name = "bluez-4.65";
   
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.gz";
    sha256 = "08j9h2cm0d4ifq8jna9lgfg37b3bncmjgxm9nirdrsr6505542sz";
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
