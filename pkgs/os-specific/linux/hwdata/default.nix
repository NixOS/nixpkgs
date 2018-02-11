{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hwdata-${version}";
  version = "0.308";

  src = fetchurl {
    url = "https://github.com/vcrhonek/hwdata/archive/v0.308.tar.gz";
    sha256 = "17zcwplw41dfwb2l9jfgvm65rjzlsbv30f56d6vgiix042f92vcq";
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
