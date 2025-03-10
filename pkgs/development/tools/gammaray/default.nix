{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qttools,
  wrapQtAppsHook,
  qtbase,
  qtwayland,
  qtsvg,
  qt3d,
  qtdeclarative,
  qtconnectivity,
  qtlocation,
  qtscxml,
  qtwebengine,
  kdePackages,
  wayland,
  elfutils,
  libbfd,
}:

stdenv.mkDerivation rec {
  pname = "gammaray";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-mJw9yckbkFVYZlcakai/hH/gAD0xOQir5JqGMNnB/dE=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    qtwayland
    qtsvg
    qt3d
    qtdeclarative
    qtconnectivity
    qtlocation
    qtscxml
    qtwebengine
    kdePackages.kcoreaddons
    wayland
    elfutils
    libbfd
  ];

  cmakeFlags = [
    # FIXME: build failed when enable BUILD_DOCS with qtwayland in buildInputs
    "-DGAMMARAY_BUILD_DOCS=OFF"
  ];

  meta = with lib; {
    description = "Software introspection tool for Qt applications developed by KDAB";
    homepage = "https://github.com/KDAB/GammaRay";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
    mainProgram = "gammaray";
  };
}
