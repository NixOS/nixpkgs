{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "hwdata-0.276";

  src = fetchurl {
    url = "https://git.fedorahosted.org/cgit/hwdata.git/snapshot/hwdata-0.276.tar.xz";
    sha256 = "0pg0ms6kb2mm25mdklsb0xn2spcwi2mhygzc7bkpji72qq8srzsh";
  };

  preConfigure = "patchShebangs ./configure";

  configureFlags = "--datadir=$(prefix)/data";

  meta = {
    homepage = "https://fedorahosted.org/hwdata/";
    description = "Hardware Database, including Monitors, pci.ids, usb.ids, and video cards";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
