{ stdenv, fetchurl, automoc4, cmake, perl, pkgconfig
, colord, libX11, libXrandr, lcms2, kdelibs
}:

stdenv.mkDerivation {
  name = "colord-kde-0.3.0";

  src = fetchurl {
    url = http://download.kde.org/stable/colord-kde/0.3.0/src/colord-kde-0.3.0.tar.bz2;
    sha256 = "ab3cdb7c8c98aa2ee8de32a92f87770e1fbd58eade6471f3f24d932b50b4cf09";
  };

  nativeBuildInputs = [ automoc4 cmake perl pkgconfig ];

  buildInputs = [ colord libX11 libXrandr lcms2 kdelibs ];

  patches = [ ./fix_check_include_files.patch ];
  patchFlags = [ "-p0" ];

  enableParallelBuilding = true;

  meta = {
    description = "A colord front-end for KDE";
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
