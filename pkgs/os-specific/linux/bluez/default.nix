{stdenv, fetchurl, pkgconfig, dbus, glib, libusb, alsaLib}:
   
assert stdenv.isLinux;
   
stdenv.mkDerivation rec {
  name = "bluez-4.54";
   
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.gz";
    sha256 = "1ykhyin06gzim4496sgr89x2yaqh4nrwmnfzrp20kiqfslw6fzlp";
  };

  buildInputs = [pkgconfig dbus.libs glib libusb alsaLib];

  configureFlags = "--localstatedir=/var";

  # Work around `make install' trying to create /var/lib/bluetooth.
  installFlags = "statedir=$(TMPDIR)/var/lib/bluetooth";

  meta = {
    homepage = http://www.bluez.org/;
    description = "Bluetooth support for Linux";
  };
}
