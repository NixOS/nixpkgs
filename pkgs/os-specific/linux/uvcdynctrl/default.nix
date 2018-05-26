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
    substituteInPlace uvcdynctrl/CMakeLists.txt \
      --replace "/etc/udev" "$out/etc/udev" \
      --replace "/lib/udev" "$out/lib/udev"
  '';

  meta = with stdenv.lib; {
    description = "A simple interface for devices supported by the linux UVC driver";
    homepage = http://guvcview.sourceforge.net;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.puffnfresh ];
    platforms = platforms.linux;
  };
}
