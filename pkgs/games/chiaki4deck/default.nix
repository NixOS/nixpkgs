{ lib
, fetchFromGitHub
, mkDerivation
, cmake
, pkg-config
, protobuf
, python3
, ffmpeg_6
, libopus
, qtbase
, qtmultimedia
, qtsvg
, SDL2
, libevdev
, udev
, hidapi
, fftw
}:

mkDerivation rec {
  pname = "chiaki4deck";
  version = "1.3.4";

  src = fetchFromGitHub {
    owner = "streetpea";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ayU2mYDpgGMgDK5AI5gwgu6h+YLKPG7P32ECWdL5wA4=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    python3
    python3.pkgs.protobuf
    python3.pkgs.setuptools
  ];

  buildInputs = [
    ffmpeg_6
    libopus
    qtbase
    qtmultimedia
    qtsvg
    protobuf
    SDL2
    hidapi
    fftw
    libevdev
    udev
  ];

  meta = with lib; {
    homepage = "https://streetpea.github.io/chiaki4deck/";
    description = "Fork of Chiaki (Open Source Playstation Remote Play) with Enhancements for Steam Deck";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ devusb ];
    platforms = platforms.linux;
    mainProgram = "chiaki";
  };
}
