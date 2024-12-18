{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
, wrapQtAppsHook
, qtbase
, wayland
, elfutils
, libbfd
}:

stdenv.mkDerivation rec {
  pname = "gammaray";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-C8bej0q4p8F27hiJUye9G+sZbkAYaV8hW1GKWZyHAis=";
  };

  patches = [
    # Qt 6.7 temp fix, change to Qt needed to fully fix
    # https://github.com/KDAB/GammaRay/pull/921
    (fetchpatch {
      url = "https://github.com/KDAB/GammaRay/commit/d76e73696800bbeda1273e04c6ec42d081fd55e4.patch";
      hash = "sha256-BEbNVfP6TDX07RHD5wo1O6na0ku3E04Bzo2z2bUBvuc=";
    })
    # Fix build on 6.7 for after QDeferredDeleteEvent export reversion
    # https://github.com/KDAB/GammaRay/pull/957
    (fetchpatch {
      url = "https://github.com/KDAB/GammaRay/commit/cf8f77f0d5e881368240a0647368757abdd6334e.patch";
      hash = "sha256-qbaB9eTJiogpszj6KY1PgfZtp5leUaQemmKGGhLxZb4=";
    })
    # Fix Qt 6.6+ build
    # https://github.com/KDAB/GammaRay/issues/827
    (fetchpatch {
      url = "https://github.com/KDAB/GammaRay/commit/9978a0a7c4f4d122477f4f14755e55196365d8ce.patch";
      hash = "sha256-l7GsHNDcT2gAL5zCSLSuLD+Pkr72VnKtiC1WOvTlxqU=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    wayland
    elfutils
    libbfd
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

