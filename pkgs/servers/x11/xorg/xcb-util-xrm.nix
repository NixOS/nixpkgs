{ stdenv, fetchurl, pkgconfig, m4, libxcb, xcbutil, libX11 }:

stdenv.mkDerivation rec {
  version = "1.0";
  name = "xcb-util-xrm-${version}";

  src = fetchurl {
    url = "https://github.com/Airblader/xcb-util-xrm/releases/download/v${version}/${name}.tar.bz2";
    sha256 = "1h5vxwpd37dqfw9yj1l4zd9c5dj30r3g0szgysr6kd7xrqgaq04l";
  };

  buildInputs = [ pkgconfig m4 libxcb xcbutil ]
    ++ stdenv.lib.optional doCheck libX11;
  doCheck = true;

  meta = with stdenv.lib; {
    description = "XCB utility functions for the X resource manager";
    homepage = https://github.com/Airblader/xcb-util-xrm;
    license = licenses.mit; # X11 variant
    platforms = with platforms; unix;
  };
}
