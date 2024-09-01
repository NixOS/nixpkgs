{ lib
, fetchFromGitHub
, stdenv
, cmake
, pkg-config
, protobuf
, python3
, ffmpeg
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
, curlFull
, hidapi
, json_c
, fftw
, miniupnpc
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
  pname = "chiaki-ng";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "streetpea";
    repo = "chiaki-ng";
    rev = "v${version}";
    hash = "sha256-wYshjduufxTxLzU2462ZRCj9WP/PZoJUOC/kGzus8ew=";
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
    ffmpeg
    libopus
    qtbase
    qtmultimedia
    qtsvg
    qtdeclarative
    qtwayland
    qtwebengine
    protobuf
    SDL2
    curlFull
    hidapi
    json_c
    fftw
    miniupnpc
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

  # handle library name discrepancy when curl not built with cmake
  postPatch = ''
    substituteInPlace lib/CMakeLists.txt \
      --replace-fail 'libcurl_shared' 'libcurl'
  '';

  cmakeFlags = [
    "-Wno-dev"
    (lib.cmakeFeature "CHIAKI_USE_SYSTEM_CURL" "true")
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
    homepage = "https://streetpea.github.io/chiaki-ng/";
    description = "Next-Generation of Chiaki (the open-source remote play client for PlayStation)";
    # Includes OpenSSL linking exception that we currently have no way
    # to represent.
    #
    # See also: <https://github.com/spdx/license-list-XML/issues/939>
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ devusb ];
    platforms = platforms.linux;
    mainProgram = "chiaki";
  };
}
