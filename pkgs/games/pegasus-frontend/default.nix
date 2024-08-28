{ lib
, fetchFromGitHub
, stdenv
, cmake
, qtbase
, qtgraphicaleffects
, qtmultimedia
, qtsvg
, qttools
, qtx11extras
, SDL2
, sqlite
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "pegasus-frontend";
  version = "0-unstable-2023-12-05";

  src = fetchFromGitHub {
    owner = "mmatyas";
    repo = "pegasus-frontend";
    rev = "86d3eed534ef8e79f412270b955dc2ffd4d172a3";
    fetchSubmodules = true;
    hash = "sha256-lUoL63yFOVwTOcsGd8+pWqgcS5b3a6uuR8M4L6OvlXM=";
  };

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtmultimedia
    qtsvg
    qtgraphicaleffects
    qtx11extras
    sqlite
    SDL2
  ];

  meta = with lib; {
    description = "Cross platform, customizable graphical frontend for launching emulators and managing your game collection";
    mainProgram = "pegasus-fe";
    homepage = "https://pegasus-frontend.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ tengkuizdihar ];
    platforms = platforms.linux;
  };
}
