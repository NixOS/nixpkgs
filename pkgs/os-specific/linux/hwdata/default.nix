{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hwdata-${version}";
  version = "0.310";

  src = fetchurl {
    url = "https://github.com/vcrhonek/hwdata/archive/v0.310.tar.gz";
    sha256 = "08mhwwc9g9cpfyxrwwviflkdk2jnqs6hc95iv4r5d59hqrj5kida";
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
