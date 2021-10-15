{ lib, fetchzip, stdenvNoCC }:

stdenvNoCC.mkDerivation rec {
  pname = "semgrep";
  version = "0.73.0";

  src = fetchzip {
    url = "https://github.com/returntocorp/semgrep/releases/download/v${version}/semgrep-v${version}-ubuntu-16.04.tgz";
    sha256 = "sha256-pdl5wqFtOW7TP/TQfj0yjtw+EkfOBGQvPOTBSuSGl0E=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp * $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "Lightweight static analysis for many languages";
    homepage = "https://semgrep.dev";
    license = licenses.lgpl21Only;
    mainProgram = "semgrep-core";
    maintainers = with maintainers; [ ambroisie ];
    platforms = [ "x86_64-linux" ];
  };
}
