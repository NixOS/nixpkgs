{
  lib,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  qttools,
  wrapQtAppsHook,
  qtbase,
  qtsvg,
}:

mkDerivation rec {
  pname = "tbe";
  version = "0.9.3.1";

  src = fetchFromGitHub {
    owner = "kaa-ching";
    repo = "tbe";
    tag = "v${version}";
    sha256 = "1ag2cp346f9bz9qy6za6q54id44d2ypvkyhvnjha14qzzapwaysj";
  };

  postPatch = ''
    sed '1i#include <vector>' -i src/model/World.h

    # fix translations not building: https://gitlab.kitware.com/cmake/cmake/-/issues/21931
    substituteInPlace i18n/CMakeLists.txt --replace qt5_create_translation qt_add_translation

    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required (VERSION 2.8.12)" "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace src/Box2D/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.8.5)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    cmake
    qttools
    wrapQtAppsHook
  ];
  buildInputs = [
    qtbase
    qtsvg
  ];
  strictDeps = true;

  installPhase = ''
    make DESTDIR=.. install
    mkdir -p $out/bin
    cp ../usr/games/tbe $out/bin
    cp -r ../usr/share $out/
  '';

  meta = with lib; {
    description = "Physics-based game vaguely similar to Incredible Machine";
    mainProgram = "tbe";
    homepage = "http://the-butterfly-effect.org/";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2Only;
  };
}
