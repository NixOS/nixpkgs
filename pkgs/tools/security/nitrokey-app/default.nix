{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  pkg-config,
  wrapQtAppsHook,
  libnitrokey,
  cppcodec,
  qttools,
}:

stdenv.mkDerivation rec {
  pname = "nitrokey-app";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "nitrokey-app";
    tag = "v${version}";
    hash = "sha256-c6EC5uuMna07xVHDRFq0UDwuSeopZTmZGZ9ZD5zaq8Y=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
    qttools
  ];

  cmakeFlags = [
    "-DADD_GIT_INFO=OFF"
    "-DBASH_COMPLETION_PATH=share/bash-completion/completions"
  ];

  buildInputs = [
    libnitrokey
    cppcodec
  ];

  # CMake 3.1 is deprecated and is no longer supported by CMake > 4
  # https://github.com/NixOS/nixpkgs/issues/445447
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "CMAKE_MINIMUM_REQUIRED(VERSION 3.1.0 FATAL_ERROR)" \
      "cmake_minimum_required(VERSION 3.10  FATAL_ERROR)" \
    --replace-fail \
      "cmake_policy(SET CMP0043 OLD)" \
      "cmake_policy(SET CMP0043 NEW)"
  '';

  meta = with lib; {
    description = "Provides extra functionality for the Nitrokey Pro and Storage";
    mainProgram = "nitrokey-app";
    longDescription = ''
      The nitrokey-app provides a QT system tray widget with which you can
      access the extra functionality of a Nitrokey Storage or Nitrokey Pro.
      See https://www.nitrokey.com/ for more information.
    '';
    homepage = "https://github.com/Nitrokey/nitrokey-app";
    changelog = "https://github.com/Nitrokey/nitrokey-app/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      kaiha
      panicgh
    ];
  };
}
