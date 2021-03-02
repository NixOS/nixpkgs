{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "hwdata";
  version = "0.345";

  src = fetchFromGitHub {
    owner = "vcrhonek";
    repo = "hwdata";
    rev = "v${version}";
    sha256 = "sha256-EXEKmx23ier1qCpc8P5H87EDVqxR+HLSQJEtdMHj3h4=";
  };

  preConfigure = "patchShebangs ./configure";

  configureFlags = [ "--datadir=${placeholder "out"}/share" ];

  doCheck = false; # this does build machine-specific checks (e.g. enumerates PCI bus)

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "011lyldzskfb4sfn4i7qyyq3i4gaf1v9yfbc82889cabka0n4nfz";

  meta = {
    homepage = "https://github.com/vcrhonek/hwdata";
    description = "Hardware Database, including Monitors, pci.ids, usb.ids, and video cards";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
  };
}
