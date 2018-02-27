{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hwdata-${version}";
  version = "0.309";

  src = fetchurl {
    url = "https://github.com/vcrhonek/hwdata/archive/v0.309.tar.gz";
    sha256 = "1njx4lhg7a0cawz82x535vk4mslmnfj7nmf8dbq8kgqxiqh6h2c7";
  };

  preConfigure = "patchShebangs ./configure";

  configureFlags = "--datadir=$(prefix)/data";

  meta = {
    homepage = https://github.com/vcrhonek/hwdata;
    description = "Hardware Database, including Monitors, pci.ids, usb.ids, and video cards";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
