{ lib, stdenvNoCC, xar }:

stdenvNoCC.mkDerivation rec {
  pname = "unpkg";
  version = "0.1.0";

  nativeBuildInputs = [ xar ];
  setupHook = ./setup-hook.sh;

  src = ./.;

  installPhase = ''
    mkdir -p $out/bin
    ln -s $(command -v xar) $out/bin/xar
  '';

  meta = with lib; {
    description = "Extract a pkg file";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ spease ];
  };
}
