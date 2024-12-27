{
  lib,
  stdenv,
  fetchurl,
  cmake,
  extra-cmake-modules,
  pkg-config,
  qtbase,
  qtdeclarative,
  qtx11extras ? null, # qt5 only
  kcoreaddons,
  ki18n,
  knotifications,
  kpipewire,
  kstatusnotifieritem ? null, # qt6 only
  kwindowsystem,
  wrapQtAppsHook,
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
    qtdeclarative
    qtx11extras
    kcoreaddons
    ki18n
    knotifications
    kpipewire
    kstatusnotifieritem
    kwindowsystem
  ];

  cmakeFlags = [ "-DQT_MAJOR_VERSION=${lib.versions.major qtbase.version}" ];

  meta = {
    description = "Utility to allow streaming Wayland windows to X applications";
    homepage = "https://invent.kde.org/system/xwaylandvideobridge";
    license = with lib.licenses; [
      bsd3
      cc0
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [ stepbrobd ];
    platforms = lib.platforms.linux;
    mainProgram = "xwaylandvideobridge";
  };
})
