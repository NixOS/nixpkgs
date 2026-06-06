{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  pkg-config,
  fcitx5,
  fcitx5-qt,
  qtbase,
  qtsvg,
  qtwayland,
  qtdeclarative,
  kitemviews,
  kwidgetsaddons,
  kcmutils,
  kcoreaddons,
  kdeclarative,
  kirigami ? null,
  isocodes,
  xkeyboard-config,
  libxkbfile,
  libplasma ? null,
  wrapQtAppsHook,
  kcmSupport ? true,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-configtool";
  version = "5.1.13";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-STx2S5fuaZCsGoM8nsihYoW+C1GdkD3K7pT84aMRI9c=";
  };

  cmakeFlags = [
    (lib.cmakeBool "KDE_INSTALL_USE_QT_SYS_PATHS" true)
    (lib.cmakeBool "ENABLE_KCM" kcmSupport)
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    fcitx5
    fcitx5-qt
    qtbase
    qtsvg
    qtwayland
    kitemviews
    kwidgetsaddons
    isocodes
    xkeyboard-config
    libxkbfile
  ]
  ++ lib.optionals kcmSupport [
    qtdeclarative
    kcoreaddons
    kdeclarative
    kcmutils
    libplasma
    kirigami
  ];

  meta = {
    description = "Configuration Tool for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-configtool";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ poscat ];
    platforms = lib.platforms.linux;
    mainProgram = "fcitx5-config-qt";
  };
}
