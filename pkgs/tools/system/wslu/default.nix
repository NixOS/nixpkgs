{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "wslu";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "wslutilities";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-DlWI+rHj1vSJzJ8VJnUfoPH6t4LQhqxJgRKqz41fVmY=";
  };

  makeFlags = [ "DESTDIR=$(out)" ];

  meta = with lib; {
    description = "A collection of utilities for Windows 10 Linux Subsystems";
    homepage = "https://github.com/wslutilities/wslu";
    changelog = "https://github.com/wslutilities/wslu/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jamiemagee ];
    platforms = platforms.linux;
  };
}
