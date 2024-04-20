{ lib
, fetchFromGitHub
, fetchpatch
, stdenv
, cmake
, pkg-config
, protobuf
, python3
, ffmpeg_6
, libopus
, wrapQtAppsHook
, qtbase
, qtmultimedia
, qtsvg
, qtwayland
, qtdeclarative
, qtwebengine
, SDL2
, libevdev
, udev
, hidapi
, fftw
, speexdsp
, libplacebo
, vulkan-loader
, vulkan-headers
, libunwind
, shaderc
, lcms2
, libdovi
, xxHash
}:

stdenv.mkDerivation rec {
  pname = "chiaki4deck";
  version = "1.6.6";

  src = fetchFromGitHub {
    owner = "streetpea";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hai7fIyeNcAURfeQtAIqOLb9j8erPNoy3zHK4rgLjc0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
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
    qtdeclarative
    qtwayland
    qtwebengine
    protobuf
    SDL2
    hidapi
    fftw
    libevdev
    udev
    speexdsp
    libplacebo
    vulkan-headers
    libunwind
    shaderc
    lcms2
    libdovi
    xxHash
  ];

  cmakeFlags = [
    "-Wno-dev"
  ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib"
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
