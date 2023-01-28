{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, ninja
, pkg-config
, systemd
, ncurses
}:

stdenv.mkDerivation rec {
  pname = "chkservice";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "linuxenko";
    repo = "chkservice";
    rev = version;
    hash = "sha256-ZllO6Ag+OgAkQp6jSv000NUEskXFuhMcCo83A4Wp2zU=";
  };

  patches = [
    # Pull fix pending upstream inclusion for gcc-11 support:
    #   https://github.com/linuxenko/chkservice/pull/38
    (fetchpatch {
      name = "gcc-11.patch";
      url = "https://github.com/linuxenko/chkservice/commit/26b12a7918c8a3bc449c92b458e6cd5c2d7b2e05.patch";
      hash = "sha256-LaJLlqRyn1eoahbW2X+hDSt8iV4lhNRn0j0kLHB+RhM=";
    })
  ];

  # Tools needed during build time
  nativeBuildInputs = [
    cmake
    # Makes the build faster, adds less than half a megabyte to the build
    # dependencies
    ninja
    pkg-config
  ];

  buildInputs = [
    systemd
    ncurses
  ];

  hardeningDisable = [ "format" ];

  meta = {
    description = "chkservice is a tool for managing systemd units in terminal.";
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ infinisil ];
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/linuxenko/chkservice";
  };
}
