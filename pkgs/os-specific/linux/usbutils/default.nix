{stdenv, fetchurl, libusb}:

stdenv.mkDerivation {
  name = "usbutils-0.71";
  src = fetchurl {
    url = http://surfnet.dl.sourceforge.net/sourceforge/linux-usb/usbutils-0.71.tar.gz;
    md5 = "479d7c7098ef44cc95e7978fd71c712c";
  };
  buildInputs = [libusb];
}
