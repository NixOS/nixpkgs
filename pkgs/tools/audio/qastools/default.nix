{ mkDerivation, lib, fetchurl, cmake, alsaLib, udev, qtbase, qtsvg, qttools }:

let
  version = "0.21.0";
in

mkDerivation {
  name = "qastools-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/qastools/${version}/qastools_${version}.tar.bz2";
    sha256 = "1zl9cn5h43n63yp3z1an87xvw554k9hlcz75ddb30lvpcczkmwrh";
  };

  buildInputs = [
    alsaLib udev qtbase qtsvg qttools
  ];
  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DALSA_INCLUDE=${alsaLib.dev}/include/alsa/version.h"
  ];

  meta = with lib; {
    description = "Collection of desktop applications for ALSA configuration";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
