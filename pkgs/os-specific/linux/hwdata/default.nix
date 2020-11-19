{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "hwdata";
  version = "0.335";

  src = fetchFromGitHub {
    owner = "vcrhonek";
    repo = "hwdata";
    rev = "v${version}";
    sha256 = "0f8ikwfrs6xd5sywypd9rq9cln8a0rf3vj6nm0adwzn1p8mgmrb2";
  };

  preConfigure = "patchShebangs ./configure";

  configureFlags = [ "--datadir=${placeholder "out"}/share" ];

  doCheck = false; # this does build machine-specific checks (e.g. enumerates PCI bus)

  outputHashMode = "recursive";
  outputHashAlgo = "sha256";
  outputHash = "101lppd1805drwd038b4njr5czzjnqqxf3xlf6v3l22wfwr2cn3l";

  meta = {
    homepage = "https://github.com/vcrhonek/hwdata";
    description = "Hardware Database, including Monitors, pci.ids, usb.ids, and video cards";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
