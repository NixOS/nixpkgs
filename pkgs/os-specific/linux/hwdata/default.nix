{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "hwdata-${version}";
  version = "0.313";

  src = fetchurl {
    url = "https://github.com/vcrhonek/hwdata/archive/v0.313.tar.gz";
    sha256 = "0x0qk2cim1mv8cl8h8rwqn8mbbs43j04rn06m81b531i182zii17";
  };

  preConfigure = "patchShebangs ./configure";

  configureFlags = "--datadir=$(prefix)/data";

  doCheck = false; # this does build machine-specific checks (e.g. enumerates PCI bus)

  meta = {
    homepage = https://github.com/vcrhonek/hwdata;
    description = "Hardware Database, including Monitors, pci.ids, usb.ids, and video cards";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
