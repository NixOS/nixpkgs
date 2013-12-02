{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "hwdata-0.249";

  src = fetchurl {
    url = "https://git.fedorahosted.org/cgit/hwdata.git/snapshot/hwdata-0.249-1.tar.bz2";
    sha256 = "1ak3h3psg3wk9yk0dqnzdzik3jadzja3ah22vjfmf71p3b5xc8ai";
  };

  preConfigure = "patchShebangs ./configure";

  configureFlags = "--datadir=$(prefix)/data";

  meta = {
    homepage = "https://fedorahosted.org/hwdata/";
    description = "Hardware Database, including Monitors, pci.ids, usb.ids, and video cards";
    license = "GPLv2";
    platforms = stdenv.lib.platforms.linux;
  };
}
