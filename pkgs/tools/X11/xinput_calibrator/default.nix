{ stdenv, fetchurl, libXi, xorgproto, autoconf, automake, libtool, m4, xlibsWrapper, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "xinput_calibrator";
  version = "0.7.5";
  name = "${pname}-${version}";
  src = fetchurl {
    url = "https://github.com/tias/${pname}/archive/v${version}.tar.gz";
    sha256 = "d8edbf84523d60f52311d086a1e3ad0f3536f448360063dd8029bf6290aa65e9";
  };

  preConfigure = "./autogen.sh --with-gui=X11";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ xorgproto libXi autoconf automake libtool m4 xlibsWrapper ];

  meta = {
    homepage = https://github.com/tias/xinput_calibrator;
    description = "A generic touchscreen calibration program for X.Org";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.flosse ];
    platforms = stdenv.lib.platforms.linux;
  };
}
