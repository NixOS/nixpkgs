{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "wslu";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "wslutilities";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-bW/otr1kqmH2N5sD3R9kYCZyn+BbBZ2fCVGlP1pFnK8=";
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
