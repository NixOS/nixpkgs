{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    (fetchpatch {
      name = "fix-build-for-Qt-6_9.patch";
      url = "https://github.com/KDAB/GammaRay/commit/750195c8172bc7c2e805cbf28d3993d65c17b5a0.patch";
      hash = "sha256-HQLOOkNmrGMoBDAK5am/NePnAF3Jsa5F0WyUjaJ2tYw=";
    })
  ];

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
