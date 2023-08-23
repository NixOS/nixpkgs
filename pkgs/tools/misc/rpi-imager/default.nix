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
