{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, gtk2, openssh }:

stdenv.mkDerivation rec {
  pname = "ssh-askpass-fullscreen";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "atj";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1GER+SxTpbMiYLwFCwLX/hLvzCIqutyvQc9DNJ7d1C0=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    gtk2
    openssh
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A small SSH askpass GUI using GTK+2";
    homepage = "https://github.com/atj/ssh-askpass-fullscreen";
    license = licenses.gpl2;
    maintainers = with maintainers; [ caadar ];
    platforms = platforms.unix;
  };
}
