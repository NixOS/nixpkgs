{ stdenv, fetchurl, pkgconfig, m4, libxcb, xcbutil, libX11 }:

stdenv.mkDerivation rec {
  version = "1.2";
  name = "xcb-util-xrm-${version}";

  src = fetchurl {
    url = "https://github.com/Airblader/xcb-util-xrm/releases/download/v${version}/${name}.tar.bz2";
    sha256 = "0vbqhag51i0njc8d5fc8c6aa12496cwrc3s6s7sa5kfc17cwhppp";
  };

  nativeBuildInputs = [ pkgconfig m4 ];
  buildInputs = [ libxcb xcbutil ]
    ++ stdenv.lib.optional doCheck libX11;
  doCheck = true;

  meta = with stdenv.lib; {
    description = "XCB utility functions for the X resource manager";
    homepage = https://github.com/Airblader/xcb-util-xrm;
    license = licenses.mit; # X11 variant
    platforms = with platforms; unix;
  };
}
