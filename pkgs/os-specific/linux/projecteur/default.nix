{
  lib,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qtbase,
  qtgraphicaleffects,
  wrapQtAppsHook,
}:

mkDerivation rec {
  pname = "projecteur";
  version = "0.10";

  src = fetchFromGitHub {
    owner = "jahnf";
    repo = "Projecteur";
    rev = "v${version}";
    fetchSubmodules = false;
    hash = "sha256-F7o93rBjrDTmArTIz8RB/uGBOYE6ny/U7ppk+jEhM5A=";
  };

  postPatch = ''
    sed '1i#include <array>' -i src/device.h # gcc12
  '';

  buildInputs = [
    qtbase
    qtgraphicaleffects
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX:PATH=${placeholder "out"}"
    "-DPACKAGE_TARGETS=OFF"
    "-DCMAKE_INSTALL_UDEVRULESDIR=${placeholder "out"}/lib/udev/rules.d"
  ];

  meta = {
    description = "Linux/X11 application for the Logitech Spotlight device (and similar devices)";
    homepage = "https://github.com/jahnf/Projecteur";
    license = lib.licenses.mit;
    mainProgram = "projecteur";
    maintainers = with lib.maintainers; [
      benneti
      drupol
    ];
    platforms = lib.platforms.linux;
  };
}
