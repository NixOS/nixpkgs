{ lib
, stdenv
, fetchFromGitLab
, cmake
, extra-cmake-modules
, pkg-config
, qtbase
, qtquickcontrols2
, qtx11extras
, kdelibs4support
, kpipewire
, wrapQtAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xwaylandvideobridge";
  version = "0.2";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "system";
    repo = "xwaylandvideobridge";
    rev = "v${finalAttrs.version}";
    hash = "sha256-79Z4BH7C85ZF+1Zivs3bTey7IdUnaDKhvZxzL6sDqUs=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtquickcontrols2
    qtx11extras
    kdelibs4support
    kpipewire
  ];

  meta = {
    description = "Utility to allow streaming Wayland windows to X applications";
    homepage = "https://invent.kde.org/system/xwaylandvideobridge";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ stepbrobd ];
    platforms = lib.platforms.linux;
    mainProgram = "xwaylandvideobridge";
  };
})
