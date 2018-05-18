{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hwdata-${version}";
  version = "0.312";

  src = fetchurl {
    url = "https://github.com/vcrhonek/hwdata/archive/v0.312.tar.gz";
    sha256 = "04dbxfn40b8vyw49qpkslv20akbqm5hwl3cndmqacp6cik1l0gai";
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
