{ lib
, stdenv
, fetchurl
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
  version = "0.4.0";

  src = fetchurl {
    url = "mirror://kde/stable/xwaylandvideobridge/xwaylandvideobridge-${finalAttrs.version}.tar.xz";
    hash = "sha256-6nKseypnV46ZlNywYZYC6tMJekb7kzZmHaIA5jkn6+Y=";
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
    license = with lib.licenses; [ bsd3 cc0 gpl2Plus ];
    maintainers = with lib.maintainers; [ stepbrobd ];
    platforms = lib.platforms.linux;
    mainProgram = "xwaylandvideobridge";
  };
})
