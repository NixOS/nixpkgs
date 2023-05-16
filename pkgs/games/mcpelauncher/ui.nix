{ lib
, callPackage
, stdenv
, fetchFromGitHub
, cmake
, wrapQtAppsHook
, zlib
, libzip
, curl
, protobuf
, qt5
, withPlayLicenseCheck ? true
}:

let
  common = callPackage ./common.nix { };
in
stdenv.mkDerivation rec {
  pname = "mcpelauncher-ui-qt";
  version = common.version;

  src = fetchFromGitHub {
    owner = common.owner;
    repo = "mcpelauncher-ui-manifest";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-qVMHH/joeCf3hV7KGZ2TxzzKSG+t46ZViYoCe9XVjzI=";
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    zlib
    libzip
    curl
    protobuf
    qt5.qtwebengine
    qt5.qtquickcontrols2
  ];

  cmakeFlags = lib.optionals (!withPlayLicenseCheck) [
    "-DLAUNCHER_ENABLE_GOOGLE_PLAY_LICENCE_CHECK=OFF"
  ];

  meta = with lib; {
    inherit (common) homepage maintainers platforms;
    description = "${common.description} - Qt UI";
    license = licenses.gpl3Plus;
  };
}
