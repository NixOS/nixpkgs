{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "hwdata-${version}";
  version = "0.313";

  src = fetchFromGitHub {
    owner = "vcrhonek";
    repo = "hwdata";
    rev = "v${version}";
    sha256 = "1mmqiy4ams14mdiakz60dm07wfan343hisiiz0dwvh685mjxap8h";
  };

  preConfigure = "patchShebangs ./configure";

  configureFlags = "--datadir=$(prefix)/data";

  doCheck = false; # this does build machine-specific checks (e.g. enumerates PCI bus)

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "0lz8pykpfw6aqkpdaqdc3jnny1iqgsqnc0wm61784xxml7zqfdvx";

  meta = {
    homepage = https://github.com/vcrhonek/hwdata;
    description = "Hardware Database, including Monitors, pci.ids, usb.ids, and video cards";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
