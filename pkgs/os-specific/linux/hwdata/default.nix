{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hwdata-${version}";
  version = "0.291";

  src = fetchurl {
    url = "http://pkgs.fedoraproject.org/repo/pkgs/hwdata/hwdata-0.291.tar.bz2/effe59bf406eb03bb295bd34e0913dd8/hwdata-0.291.tar.bz2";
    sha256 = "01cq9csryxcrilnqdjd2r8gpaap3mk4968v7y36c7shyyaf9zkym";
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
