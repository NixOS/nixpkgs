{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "hwdata";
  version = "0.374";

  src = fetchFromGitHub {
    owner = "vcrhonek";
    repo = "hwdata";
    rev = "v${version}";
    hash = "sha256-RvjYd8iD6JkGhh6TDy/Qo+UzLxbhPvIJvhl/Rw14lbk=";
  };

  postPatch = ''
    patchShebangs ./configure
  '';

  configureFlags = [ "--datadir=${placeholder "out"}/share" ];

  doCheck = false; # this does build machine-specific checks (e.g. enumerates PCI bus)

  meta = {
    homepage = "https://github.com/vcrhonek/hwdata";
    description = "Hardware Database, including Monitors, pci.ids, usb.ids, and video cards";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ pedrohlc ];
    platforms = lib.platforms.all;
  };
}
