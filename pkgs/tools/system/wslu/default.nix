{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation rec {
  pname = "wslu";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "wslutilities";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-yhugh836BoSISbTu19ubLOrz5X31Opu5QtCR0DXrbWc=";
  };

  makeFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
  ];

  meta = with lib; {
    description = "A collection of utilities for Windows Subsystem for Linux";
    homepage = "https://github.com/wslutilities/wslu";
    changelog = "https://github.com/wslutilities/wslu/releases/tag/v${version}";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jamiemagee ];
    platforms = platforms.linux;
  };
}
