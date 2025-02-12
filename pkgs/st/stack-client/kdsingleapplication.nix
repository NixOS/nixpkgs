{ lib, stdenv, fetchFromGitHub, cmake, extra-cmake-modules, qt6 }:

stdenv.mkDerivation rec {
  pname = "kdsingleapplication-qt6";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = "KDSingleApplication";
    rev = "v${version}";
    sha256 = "sha256-Ymm+qOZMWULg7u5xEpGzcAfIrbWBQ3jsndnFSnh6/PA=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules qt6.wrapQtAppsHook ];
  buildInputs = [ qt6.qtbase ];

  cmakeFlags =
    [ "-DKDSingleApplication_QT6=ON" "-DKDSingleApplication_EXAMPLES=OFF" ];

  meta = with lib; {
    description = "Single instance application library for Qt6";
    homepage = "https://github.com/KDAB/KDSingleApplication";
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

