{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "wslu";
  version = "3.2.4";

  src = fetchFromGitHub {
    owner = "wslutilities";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bZFccqFZF6Xt0yAw6JSONNhosBliHQc7KJQ8Or7UvMA=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "A collection of utilities for Windows 10 Linux Subsystems";
    homepage = "https://github.com/wslutilities/wslu";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jamiemagee ];
    platforms = platforms.linux;
  };
}
