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
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-CJKb7H77PjPwCGW4fqLSJw1mhSweuFYlDE/7RyVDcT0=";
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
    changelog = "https://github.com/KDAB/GammaRay/releases/tag/${src.tag}";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wineee ];
    mainProgram = "gammaray";
  };
}
