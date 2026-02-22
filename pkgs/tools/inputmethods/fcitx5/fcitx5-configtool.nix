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
  qtx11extras ? null,
  kitemviews,
  kwidgetsaddons,
  qtquickcontrols2 ? null,
  kcmutils,
  kcoreaddons,
  kdeclarative,
  kirigami ? null,
  kirigami2 ? null,
  isocodes,
  xkeyboard-config,
  libxkbfile,
  libplasma ? null,
  plasma-framework ? null,
  wrapQtAppsHook,
  kcmSupport ? true,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-configtool";
  version = "5.1.12";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-XwVvkxG5627E5BE2Yp0w/mFjaG1nYa0Olm8Gz6V4+eA=";
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
  ++ lib.optionals (lib.versions.major qtbase.version == "5") [
    qtx11extras
  ]
  ++ lib.optionals kcmSupport (
    [
      qtdeclarative
      kcoreaddons
      kdeclarative
    ]
    ++ lib.optionals (lib.versions.major qtbase.version == "5") [
      qtquickcontrols2
      plasma-framework
      kirigami2
    ]
    ++ lib.optionals (lib.versions.major qtbase.version == "6") [
      kcmutils
      libplasma
      kirigami
    ]
  );

  meta = {
    description = "Configuration Tool for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-configtool";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ poscat ];
    platforms = lib.platforms.linux;
    mainProgram = "fcitx5-config-qt";
  };
}
