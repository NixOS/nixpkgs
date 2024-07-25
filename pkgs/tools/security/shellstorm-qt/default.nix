{ pkgs ? import <nixpkgs> {}
, stdenv ? pkgs.stdenv
, qtbase ? pkgs.qt6.qtbase
, full ? pkgs.qt6.full
, cmake ? pkgs.cmake
, wrapQtAppsHook ? pkgs.qt6.wrapQtAppsHook
, fetchFromGitHub ? pkgs.fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "shellstorm-qt";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "algoatson";
    repo = "shellstorm-qt";
    rev = "c4eb37395e28fe25dd7312c9414d85a160e46457"; # or another commit, tag, or branch
    sha256 = "sha256-KbdqGVqOz8CLPBOGiC5qsOpLW4Rzoalnsl0l55afJ7s";
  };

  buildInputs = [
    qtbase
    full
  ];

  # cmakeFlags = [
  #   "-DCMAKE_BUILD_TYPE=Release"
  #
  # ];
  configurePhase = ''
    cd src
    cmake .
  '';

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildPhase = ''
    cmake --build . --config Release
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./shellstorm-qt $out/bin/
  '';
}
