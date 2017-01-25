{ stdenv, fetchurl, cmake, alsaLib, udev, qtbase,
  qtsvg, qttools, makeQtWrapper }:

let
  version = "0.21.0";
in

stdenv.mkDerivation {
  name = "qastools-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/project/qastools/${version}/qastools_${version}.tar.bz2";
    sha256 = "1zl9cn5h43n63yp3z1an87xvw554k9hlcz75ddb30lvpcczkmwrh";
  };

  buildInputs = [
    cmake alsaLib udev qtbase qtsvg qttools makeQtWrapper
  ];

  cmakeFlags = [
    "-DCMAKE_INSALL_PREFIX=$out"
    "-DALSA_INCLUDE=${alsaLib.dev}/include/alsa/version.h"
  ];

  meta = with stdenv.lib; {
    description = "Collection of desktop applications for ALSA configuration";
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
