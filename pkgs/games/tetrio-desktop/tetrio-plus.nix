{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {
  pname = "tetrio-plus";
  version = "0.25.2";

  src = fetchzip {
    url = "https://gitlab.com/UniQMG/tetrio-plus/uploads/5c720489d2bcd35629b4f8a1f36d28b1/tetrio-plus_0.25.2_app.asar.zip";
    sha256 = "sha256-8Xc2wftRYIMZ2ee67IJEIGGrAAS02CL0XzDqQ/luYVE=";
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
