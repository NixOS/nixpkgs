{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "material-you-theme";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "material-you-theme";
    tag = version;
    hash = "sha256-xJXhvKwp/l08/ZWi3OcGPmCdsUiMjBDwrKz5OIpD2t8=";
  };

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp themes/material_you.yaml $out

    runHook postInstall
  '';

  meta = with lib; {
    description = "Material Design 3 Theme for Home Assistant";
    homepage = "https://github.com/Nerwyn/material-you-theme";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpinz ];
    platforms = platforms.all;
  };
}
