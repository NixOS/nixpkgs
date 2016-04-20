{ stdenv, fetchurl, cmake, alsaLib, udev, qt4 }:

let
  version = "0.18.1";
in

stdenv.mkDerivation {
  name = "qastools-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/qastools/qastools_${version}.tar.bz2";
    sha256 = "1sac6a0j1881wgpv4491b2f4jnhqkab6xyldmcg1wfqb5qkdgzvg";
  };

  buildInputs = [
    cmake alsaLib udev qt4
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
