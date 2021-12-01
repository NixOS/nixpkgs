{ lib, stdenv, fetchFromGitHub, qmake, libXxf86vm, wrapQtAppsHook }:

let
  pname = "gammy";
  version = "0.9.64";
in

stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "Fushko";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-NPvkT7jSbDjcZDHpMIOik9fNsz7OJXQ3g9OFxkpA3pk=";
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
