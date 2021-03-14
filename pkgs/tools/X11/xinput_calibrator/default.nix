{ lib, stdenv, fetchurl, libXi, xorgproto, autoconf, automake, libtool, m4, xlibsWrapper, pkg-config }:

stdenv.mkDerivation rec {
  pname = "xinput_calibrator";
  version = "0.7.5";
  src = fetchurl {
    url = "https://github.com/tias/${pname}/archive/v${version}.tar.gz";
    sha256 = "d8edbf84523d60f52311d086a1e3ad0f3536f448360063dd8029bf6290aa65e9";
  };

  preConfigure = "./autogen.sh --with-gui=X11";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ xorgproto libXi autoconf automake libtool m4 xlibsWrapper ];

  meta = {
    homepage = "https://github.com/tias/xinput_calibrator";
    description = "A generic touchscreen calibration program for X.Org";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.flosse ];
    platforms = lib.platforms.linux;
  };
}
