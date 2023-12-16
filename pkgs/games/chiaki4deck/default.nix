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
, speexdsp
}:

mkDerivation rec {
  pname = "chiaki4deck";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "streetpea";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XNpD9JPbckiq0HgpV/QJR8hDmvGTptxBMoGihHz44lc=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    protobuf
    python3
    python3.pkgs.wrapPython
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
    speexdsp
  ];

  pythonPath = [
    python3.pkgs.requests
  ];

  postInstall = ''
    install -Dm755 $src/scripts/psn-account-id.py $out/bin/psn-account-id
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with lib; {
    homepage = "https://streetpea.github.io/chiaki4deck/";
    description = "Fork of Chiaki (Open Source Playstation Remote Play) with Enhancements for Steam Deck";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ devusb ];
    platforms = platforms.linux;
    mainProgram = "chiaki";
  };
}
