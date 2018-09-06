{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "hwdata-${version}";
  version = "0.314";

  src = fetchFromGitHub {
    owner = "vcrhonek";
    repo = "hwdata";
    rev = "v${version}";
    sha256 = "12k466ndg152fqld1w5v1zfdyv000yypazcwy75ywlxvlknv4y90";
  };

  preConfigure = "patchShebangs ./configure";

  configureFlags = [ "--datadir=$(prefix)/data" ];

  doCheck = false; # this does build machine-specific checks (e.g. enumerates PCI bus)

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "1w00y5kj8rd8slzydw1gw8cablxlkham4vq786kdd8zga286zabb";

  meta = {
    homepage = https://github.com/vcrhonek/hwdata;
    description = "Hardware Database, including Monitors, pci.ids, usb.ids, and video cards";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
