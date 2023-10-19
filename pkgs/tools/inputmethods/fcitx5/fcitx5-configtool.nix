{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, extra-cmake-modules
, fcitx5
, fcitx5-qt
, qtx11extras
, qtquickcontrols2
, kwidgetsaddons
, kdeclarative
, kirigami2
, isocodes
, xkeyboardconfig
, libxkbfile
, libXdmcp
, plasma5Packages
, plasma-framework
, kcmSupport ? true
}:

mkDerivation rec {
  pname = "fcitx5-configtool";
  version = "5.1.1";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "sha256-5f75UTGCWsuMdZKhssSpUiVaRR05YY0bumVUNq2wJtY=";
  };

  cmakeFlags = [
    "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    fcitx5
    fcitx5-qt
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
    plasma5Packages.kiconthemes
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
