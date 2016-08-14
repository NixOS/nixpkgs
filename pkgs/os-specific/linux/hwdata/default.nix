{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hwdata-${version}";
  version = "0.291";

  src = fetchurl {
    url = "https://git.fedorahosted.org/cgit/hwdata.git/snapshot/hwdata-${version}.tar.xz";
    sha256 = "121qixrdhdncva1cnj7m7jlqvi1kbj85dpi844jiis3a8hgpzw5a";
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
