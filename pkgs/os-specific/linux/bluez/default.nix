{stdenv, fetchurl, pkgconfig, dbus, glib, libusb, alsaLib}:
   
assert stdenv.isLinux;
   
stdenv.mkDerivation rec {
  name = "bluez-4.47";
   
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.gz";
    sha256 = "0xiv26q1cgddby90pvc7f36xh6ky73c2w8gfmc4wgc1nd3dbf2w3";
  };

  buildInputs = [pkgconfig dbus.libs glib libusb alsaLib];

  meta = {
    homepage = http://www.bluez.org/;
    description = "Bluetooth support for Linux";
  };
}
