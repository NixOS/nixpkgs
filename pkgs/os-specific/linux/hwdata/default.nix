{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "hwdata";
  version = "0.343";

  src = fetchFromGitHub {
    owner = "vcrhonek";
    repo = "hwdata";
    rev = "v${version}";
    sha256 = "sha256-sK9kbjuq3mDSdtW0Y2cHSgrrCtU5Kr/eOjF/Mwe752o=";
  };

  preConfigure = "patchShebangs ./configure";

  configureFlags = [ "--datadir=${placeholder "out"}/share" ];

  doCheck = false; # this does build machine-specific checks (e.g. enumerates PCI bus)

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "0zxypzwncx2ql06f19wrm315fn7x2lfsrg9fhl3nr4zwvdksf7jw";

  meta = {
    homepage = "https://github.com/vcrhonek/hwdata";
    description = "Hardware Database, including Monitors, pci.ids, usb.ids, and video cards";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
  };
}
