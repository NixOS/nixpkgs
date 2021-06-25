{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "hwdata";
  version = "0.347";

  src = fetchFromGitHub {
    owner = "vcrhonek";
    repo = "hwdata";
    rev = "v${version}";
    sha256 = "19kmz25zq6qqs67ppqhws4mh3qf6zrp55cpyxyw36q95yjdcqp21";
  };

  preConfigure = "patchShebangs ./configure";

  configureFlags = [ "--datadir=${placeholder "out"}/share" ];

  doCheck = false; # this does build machine-specific checks (e.g. enumerates PCI bus)

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "0haaczd6pi9q2vdlvbwn7100sb87zsy64z94xhpbmlari4vzjmz0";

  meta = {
    homepage = "https://github.com/vcrhonek/hwdata";
    description = "Hardware Database, including Monitors, pci.ids, usb.ids, and video cards";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
}
