{ lib, stdenv, fetchFromGitHub, qmake, libXxf86vm, wrapQtAppsHook }:

let
  pname = "gammy";
  version = "0.9.62";
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "Fushko";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-fyr+khLgaX5xbKCW3pqt6fFvZBHGEVs1BsMireZDxP0=";
  };

  nativeBuildInputs = [ qmake wrapQtAppsHook ];

  buildInputs = [ libXxf86vm ];

  meta = with lib; {
    description = "GUI tool for manual- of auto-adjusting of brightness/temperature";
    homepage = "https://github.com/Fushko/gammy";
    license = licenses.gpl3;
    maintainers = with maintainers; [ atemu ];
    platforms = platforms.linux;
  };
}
