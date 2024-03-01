{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, extra-cmake-modules
, fcitx5
, fcitx5-qt
, qtbase
, qtsvg
, wrapQtAppsHook
, qtx11extras
, qtquickcontrols2
, kwidgetsaddons
, kdeclarative
, kirigami2
, isocodes
, xkeyboardconfig
, libxkbfile
, libXdmcp
, kiconthemes
, plasma-framework
, kcmSupport ? true
}:

let
  isQt6 = lib.versions.major qtbase.version == "6";
in stdenv.mkDerivation rec {
  pname = "fcitx5-configtool";
  version = "5.1.3";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "sha256-IwGlhIeON0SenW738p07LWZAzVDMtxOSMuUIAgfmTEg=";
  };

  cmakeFlags = [
    (lib.cmakeBool "USE_QT6" isQt6)
    "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    extra-cmake-modules
    wrapQtAppsHook
  ];

  buildInputs = [
    fcitx5
    fcitx5-qt
    qtbase
    qtsvg
    qtx11extras
    qtquickcontrols2
    kirigami2
    isocodes
    xkeyboardconfig
    libxkbfile
    libXdmcp
  ] ++ lib.optionals kcmSupport [
    kdeclarative
    kwidgetsaddons
    kiconthemes
    plasma-framework
  ];

  meta = with lib; {
    description = "Configuration Tool for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-configtool";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
    mainProgram = "fcitx5-config-qt";
  };
}
