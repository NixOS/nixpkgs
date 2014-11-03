{ stdenv, fetchurl, cmake, colord, libX11, libXrandr, lcms2, pkgconfig, kdelibs}:

stdenv.mkDerivation {
  name = "colord-kde-0.3.0";

  src = fetchurl {
    url = http://download.kde.org/stable/colord-kde/0.3.0/src/colord-kde-0.3.0.tar.bz2;
    sha256 = "ab3cdb7c8c98aa2ee8de32a92f87770e1fbd58eade6471f3f24d932b50b4cf09";
  };

  buildInputs = [ cmake colord libX11 libXrandr lcms2 pkgconfig kdelibs ];

  enableParallelBuilding = true;

  meta = {
    description = "A colord front-end for KDE";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
