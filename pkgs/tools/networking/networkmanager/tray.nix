{
  lib,
  mkDerivation,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qttools,
  qtbase,
  networkmanager-qt,
  modemmanager-qt,
}:

mkDerivation rec {
  pname = "nm-tray";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "palinek";
    repo = pname;
    rev = version;
    sha256 = "sha256-JTH1cmkgdW2aRWMYPRvOAvCJz0ClCIpjUtcWcqJQGSU=";
  };

  postPatch = ''
    sed -i -e '1i#include <QMetaEnum>' src/nmmodel.cpp
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
  ];

  cmakeFlags = [ "-DWITH_MODEMMANAGER_SUPPORT=ON" ];

  buildInputs = [
    qtbase
    networkmanager-qt
    modemmanager-qt
  ];

  meta = with lib; {
    description = "Simple Network Manager frontend written in Qt";
    mainProgram = "nm-tray";
    homepage = "https://github.com/palinek/nm-tray";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ dtzWill ];
    platforms = platforms.linux;
  };
}
