{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "tetrio-plus";
  version = "0.23.13";

  src = fetchzip {
    url = "https://gitlab.com/UniQMG/tetrio-plus/uploads/a9647feffc484304ee49c4d3fd4ce718/tetrio-plus_0.23.13_app.asar.zip";
    sha256 = "sha256-NSOVZjm4hDXH3f0gFG8ijLmdUTyMRFYGhxpwysoYIVg=";
  };

  installPhase = ''
    runHook preInstall

    install app.asar $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "TETR.IO customization toolkit";
    homepage = "https://gitlab.com/UniQMG/tetrio-plus";
    license = licenses.mit;
    maintainers = with maintainers; [ huantian ];
    platforms = [ "x86_64-linux" ];
  };
}
