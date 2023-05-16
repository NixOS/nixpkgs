<<<<<<< HEAD
{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, cmake
, util-linux
, curl
, libarchive
, qtbase
, qtdeclarative
, qtsvg
, qttools
, qtquickcontrols2
, qtgraphicaleffects
, nix-update-script
, enableTelemetry ? false
}:

stdenv.mkDerivation rec {
  pname = "rpi-imager";
  version = "1.7.5";
=======
{ mkDerivation,
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  curl,
  libarchive,
  util-linux,
  qtbase,
  qtdeclarative,
  qtsvg,
  qttools,
  qtquickcontrols2,
  qtgraphicaleffects
}:

mkDerivation rec {
  pname = "rpi-imager";
  version = "1.7.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-yB+H1zWL40KzxOrBuvg7nBC3zmWilsOgOW7ndiDWuDA=";
  };

  nativeBuildInputs = [
    cmake
    util-linux
    wrapQtAppsHook
  ];

  # Disable telemetry and update check.
  cmakeFlags = lib.optionals (!enableTelemetry) [
    "-DENABLE_CHECK_VERSION=OFF"
    "-DENABLE_TELEMETRY=OFF"
  ];
=======
    sha256 = "sha256-ahETmUhlPZ3jpxmzDK5pS6yLc6UxCJFOtWolAtSrDVQ=";
  };

  nativeBuildInputs = [ cmake util-linux ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  buildInputs = [
    curl
    libarchive
    qtbase
    qtdeclarative
    qtsvg
    qttools
    qtquickcontrols2
    qtgraphicaleffects
  ];

  sourceRoot = "${src.name}/src";

  /* By default, the builder checks for JSON support in lsblk by running "lsblk --json",
    but that throws an error, as /sys/dev doesn't exist in the sandbox.
    This patch removes the check. */
  patches = [ ./lsblkCheckFix.patch ];

<<<<<<< HEAD
  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    # Without this, the tests fail because they cannot create the QT Window
    export QT_QPA_PLATFORM=offscreen
    $out/bin/rpi-imager --version

    runHook postInstallCheck
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Raspberry Pi Imaging Utility";
    homepage = "https://www.raspberrypi.com/software/";
    changelog = "https://github.com/raspberrypi/rpi-imager/releases/tag/v${version}";
    downloadPage = "https://github.com/raspberrypi/rpi-imager/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ymarkus anthonyroussel ];
=======
  meta = with lib; {
    description = "Raspberry Pi Imaging Utility";
    homepage = "https://www.raspberrypi.org/software/";
    downloadPage = "https://github.com/raspberrypi/rpi-imager/";
    license = licenses.asl20;
    maintainers = with maintainers; [ ymarkus ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.all;
    # does not build on darwin
    broken = stdenv.isDarwin;
  };
}
