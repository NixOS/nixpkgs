{ stdenv, fetchurl, pkgconfig, dbus, glib, libusb, alsaLib }:

assert stdenv.isLinux;
   
stdenv.mkDerivation rec {
  name = "bluez-4.66";
   
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.gz";
    sha256 = "19by1ay2lifczcn8b7wppm0fcnp33yzd1vzldrzz3cgh1nwcn8y2";
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
