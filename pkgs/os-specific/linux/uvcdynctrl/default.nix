{ stdenv, fetchFromGitHub, cmake, pkgconfig, libxml2 }:

stdenv.mkDerivation rec {
  version = "0.3.0";
  name = "uvcdynctrl-${version}";

  src = fetchFromGitHub {
    owner = "cshorler";
    repo = "webcam-tools";
    rev = "bee2ef3c9e350fd859f08cd0e6745871e5f55cb9";
    sha256 = "0s15xxgdx8lnka7vi8llbf6b0j4rhbjl6yp0qxaihysf890xj73s";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libxml2 ];

  prePatch = ''
    sed -i "s|/etc/udev|$out/etc/udev|g" uvcdynctrl/CMakeLists.txt
    sed -i "s|/lib/udev|$out/lib/udev|g" uvcdynctrl/CMakeLists.txt
  '';

  meta = {
    description = "A simple interface for devices supported by the linux UVC driver";
    homepage = http://guvcview.sourceforge.net;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.puffnfresh ];
    platforms = stdenv.lib.platforms.linux;
  };
}
