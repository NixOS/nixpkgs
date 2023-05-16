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
<<<<<<< HEAD
  version = "5.1.0";
=======
  version = "5.0.17";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-kjoAcoqLJ8XHMI6NUr5DZfltWfX3GPco3VGseze6qbw=";
=======
    sha256 = "sha256-nYHrJBcbaYxZ61OEFfnwTTsZFEBtDJkR0kuYPyTcjio=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
