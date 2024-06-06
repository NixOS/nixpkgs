{ lib
, stdenv
, fetchFromGitHub
, cmake
, yaml-cpp
, qtbase
, qtsvg
, wrapQtAppsHook
, qttools
, libusb1
, php
, hidapi
, procps
}:

stdenv.mkDerivation rec {
  pname = "bloom";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "bloombloombloom";
    repo = "Bloom";
    rev = "v${version}";
    hash = "sha256-ZZfclZwxsCgApUII79bJVyT5V/dF9jm7l8ynRWCh0UU=";
  };

  nativeBuildInputs = [
    cmake
    php
    wrapQtAppsHook
  ];

  buildInputs = [
    hidapi
    libusb1
    procps
    qtbase
    qtsvg
    qttools
    yaml-cpp
  ];

  postPatch = ''
    sed -i 's|/usr|${placeholder "out"}|' cmake/Installing.cmake
  '';

  meta = {
    description = "Debug interface for AVR-based embedded systems development on GNU/Linux";
    homepage = "https://bloom.oscillate.io/";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "bloom";
    platforms = lib.platforms.linux;
  };
}
