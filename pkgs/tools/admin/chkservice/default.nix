{ stdenv, fetchFromGitHub, cmake, ninja, pkg-config, systemd, ncurses, lib }:

stdenv.mkDerivation rec {
  pname = "chkservice";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "linuxenko";
    repo = "chkservice";
    rev = version;
    hash = "sha256:0dfvm62h6dwg18f17fn58nr09mfh6kylm8wy88j00fiy13l4wnb6";
  };

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
