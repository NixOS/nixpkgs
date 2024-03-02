{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, fcitx5
, fcitx5-qt
, gettext
, qtbase
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-unikey";
  version = "5.1.3";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-unikey";
    rev = version;
    sha256 = "sha256-wrsA0gSexOZgsJunozt49GyP9R3Xe2Aci7Q8p3zAM9Q=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    qtbase
    fcitx5
    fcitx5-qt
    gettext
  ];

  cmakeFlags = [
    (lib.cmakeBool "USE_QT6" (lib.versions.major qtbase.version == "6"))
  ];

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Unikey engine support for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-unikey";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ berberman ];
    platforms = platforms.linux;
  };
}
