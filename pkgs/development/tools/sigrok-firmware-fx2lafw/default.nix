{ lib
, stdenv
, fetchurl
, sdcc
}:

stdenv.mkDerivation rec {
  pname = "sigrok-firmware-fx2lafw";
  version = "0.1.7";

  src = fetchurl {
    url = "https://sigrok.org/download/source/sigrok-firmware-fx2lafw/sigrok-firmware-fx2lafw-${version}.tar.gz";
    sha256 = "sha256-o/RA1qhSpG4sXRmfwcjk2s0Aa8BODVV2KY7lXQVqzjs=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ sdcc ];

  meta = with lib; {
    description = "Firmware for FX2 logic analyzers";
    homepage = "https://sigrok.org/";

    # licensing details explained in:
    # https://sigrok.org/gitweb/?p=sigrok-firmware-fx2lafw.git;a=blob;f=README;hb=HEAD#l122
    license = with licenses; [
      gpl2Plus    # overall
      lgpl21Plus  # fx2lib, Hantek 6022BE, Sainsmart DDS120 firmwares
    ];

    platforms = platforms.all;
    maintainers = with maintainers; [ panicgh ];
  };
}
