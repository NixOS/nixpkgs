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
  kcoreaddons,
  kdeclarative,
  kirigami ? null,
  kirigami2 ? null,
  isocodes,
  xkeyboardconfig,
  libxkbfile,
  libplasma ? null,
  plasma-framework ? null,
  wrapQtAppsHook,
  kcmSupport ? true,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-configtool";
  version = "5.1.6";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-ZB0YH5IYYjYunsVQtFaVVBW+zkTn/bgtMEWE376IoiU=";
  };

  cmakeFlags = [
    (lib.cmakeBool "KDE_INSTALL_USE_QT_SYS_PATHS" true)
    (lib.cmakeBool "ENABLE_KCM" kcmSupport)
    (lib.cmakeBool "USE_QT6" (lib.versions.major qtbase.version == "6"))
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs =
    [
      fcitx5
      fcitx5-qt
      qtbase
      qtsvg
      qtwayland
      kitemviews
      kwidgetsaddons
      isocodes
      xkeyboardconfig
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
        libplasma
        kirigami
      ]
    );

  meta = with lib; {
    description = "Configuration Tool for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-configtool";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
    mainProgram = "fcitx5-config-qt";
  };
}
