{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  munge,
  lua,
  libcap,
  perl,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "diod";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "chaos";
    repo = "diod";
    tag = "v${version}";
    hash = "sha256-Fz+qvgw5ipyAcZlWBGkmSHuGrZ95i5OorLN3dkdsYKU=";
  };

  postPatch = ''
    sed -i configure.ac -e '/git describe/c ${version})'
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    munge
    lua
    libcap
    perl
    ncurses
  ];

  configureFlags = [
    "--with-systemdsystemunitdir=$(out)/lib/systemd/system/"
    "--sysconfdir=/etc"
  ];

  meta = {
    description = "I/O forwarding server that implements a variant of the 9P protocol";
    maintainers = with lib.maintainers; [ rnhmjoj ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
