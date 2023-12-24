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
, testers
, nix-update-script
, enableTelemetry ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rpi-imager";
  version = "1.8.4";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = finalAttrs.pname;
    rev = "refs/tags/v${finalAttrs.version}";
    sha256 = "sha256-ZuS/fhPpVlLSdaD+t+qIw6fdEbi7c82X+BxcgWlPntg=";
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

  sourceRoot = "${finalAttrs.src.name}/src";

  /* By default, the builder checks for JSON support in lsblk by running "lsblk --json",
    but that throws an error, as /sys/dev doesn't exist in the sandbox.
    This patch removes the check. */
  patches = [ ./lsblkCheckFix.patch ];

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "QT_QPA_PLATFORM=offscreen rpi-imager --version";
    };
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Raspberry Pi Imaging Utility";
    homepage = "https://www.raspberrypi.com/software/";
    changelog = "https://github.com/raspberrypi/rpi-imager/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/raspberrypi/rpi-imager/";
    license = licenses.asl20;
    mainProgram = "rpi-imager";
    maintainers = with maintainers; [ ymarkus anthonyroussel ];
    platforms = platforms.all;
    # does not build on darwin
    broken = stdenv.isDarwin;
  };
})
