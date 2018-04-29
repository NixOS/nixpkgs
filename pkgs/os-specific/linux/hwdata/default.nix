{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hwdata-${version}";
  version = "0.311";

  src = fetchurl {
    url = "https://github.com/vcrhonek/hwdata/archive/v0.311.tar.gz";
    sha256 = "159av9wvl3biryxd5pgqcwz6wkdaa0ydmcysmzznx939mfv7w18z";
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
