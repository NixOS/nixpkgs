{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "udev-103";
  src = fetchurl {
    url = http://www.us.kernel.org/pub/linux/utils/kernel/hotplug/udev-103.tar.bz2;
    md5 = "7360ce47b5ec3f9fa71f18071ecb8b97";
  };
  patches = [./udev-091-installpath.patch];
}
