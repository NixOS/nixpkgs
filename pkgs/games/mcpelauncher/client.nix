{ lib
, callPackage
, clangStdenv
, fetchFromGitHub
, cmake
, pkg-config
, wrapQtAppsHook
, openssl
, zlib
, libpng
, libglvnd
, xorg
, libevdev
, curl
, qtwebengine
, pulseaudio
, qt5
, glfw
, withQtWebview ? true
, withQtErrorWindow ? true
, withGLFW? false
}:

let
  common = callPackage ./common.nix { };
in
# gcc doesn't support __has_feature
clangStdenv.mkDerivation rec {
  pname = "mcpelauncher-client";
  version = common.version;

  src = fetchFromGitHub {
    owner = common.owner;
    repo = "mcpelauncher-manifest";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-BEl02QL63dJ5VIF50+7BsSrBrhIQWXl/ZedpgGUbrjk=";
  };

  patches = [
    ./dont_download_nlohmann_json.patch
  ] ++ lib.optionals withGLFW [
    ./dont_download_glfw.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals (withQtWebview || withQtErrorWindow) [
    wrapQtAppsHook
  ];

  buildInputs = [
    openssl
    common.nlohmann_json_373
    zlib
    libpng
    libglvnd
    xorg.libX11
    libevdev
    curl
    pulseaudio
  ] ++ lib.optionals withQtWebview [
    qtwebengine
  ] ++ lib.optionals withGLFW [
    qt5.qttools
    glfw
  ];

  cmakeFlags = [
    "-DUSE_OWN_CURL=OFF"
    "-DENABLE_DEV_PATHS=OFF"
    "-Wno-dev"
  ] ++ lib.optionals (!withQtWebview) [
    "-DBUILD_WEBVIEW=OFF"
    "-DXAL_WEBVIEW_USE_CLI=ON"
    "-DXAL_WEBVIEW_USE_QT=OFF"
  ] ++ lib.optionals (!withQtErrorWindow) [
    "-DENABLE_QT_ERROR_UI=OFF"
  ] ++ lib.optionals withGLFW [
    "-DGAMEWINDOW_SYSTEM=GLFW"
  ];

  meta = with lib; {
    inherit (common) homepage maintainers platforms;
    description = "${common.description} - CLI launcher";
    license = licenses.gpl3Plus;
  };
}
