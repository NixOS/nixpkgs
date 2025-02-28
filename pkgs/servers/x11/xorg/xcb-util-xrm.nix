{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  m4,
  libxcb,
  xcbutil,
  libX11,
}:

stdenv.mkDerivation rec {
  version = "1.3";
  pname = "xcb-util-xrm";

  src = fetchurl {
    url = "https://github.com/Airblader/xcb-util-xrm/releases/download/v${version}/${pname}-${version}.tar.bz2";
    sha256 = "118cj1ybw86pgw0l5whn9vbg5n5b0ijcpx295mwahzi004vz671h";
  };

  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
    m4
  ];
  doCheck = true;
  buildInputs = [
    libxcb
    xcbutil
    libX11
  ];

  meta = with lib; {
    description = "XCB utility functions for the X resource manager";
    homepage = "https://github.com/Airblader/xcb-util-xrm";
    license = licenses.mit; # X11 variant
    platforms = with platforms; unix;
  };
}
