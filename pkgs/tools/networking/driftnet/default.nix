{ lib
, stdenv
, autoreconfHook
, cairo
, fetchFromGitHub
, giflib
, glib
, gtk2-x11
, libjpeg
, libpcap
, libpng
, libuv
, libwebsockets
, libwebp
, openssl
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "driftnet";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "deiv";
    repo = "driftnet";
    rev = "refs/tags/v${version}";
    hash = "sha256-szmezYnszlRanq8pMD0CIGA+zTYGSwSHcDaZ2Gx1KCA=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    cairo
    giflib
    glib
    gtk2-x11
    libjpeg
    libpcap
    libpng
    libuv
    libwebsockets
    libwebp
    openssl
  ];

  meta = with lib; {
    description = "Watches network traffic, and picks out and displays JPEG and GIF images for display";
    homepage = "https://github.com/deiv/driftnet";
    changelog = "https://github.com/deiv/driftnet/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ offline ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
