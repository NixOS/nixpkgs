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

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = pname;
    rev = "v${version}";
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
    platforms = platforms.all;
    # does not build on darwin
    broken = stdenv.isDarwin;
  };
}
