{ lib
, stdenv
, fetchFromGitHub
, wrapQtAppsHook
, cmake
, pkg-config
, util-linux
, curl
, libarchive
, qtbase
, qtdeclarative
, qtsvg
, qttools
, qtquickcontrols2
, qtgraphicaleffects
, xz
, nix-update-script
, enableTelemetry ? false
}:

stdenv.mkDerivation rec {
  pname = "rpi-imager";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-drHiZ0eYYvJg6/v3oEozGAbBKm1KLpec+kYZWwpT9yM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
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
    xz
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
