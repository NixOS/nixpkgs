{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "material-you-theme";
  version = "5.0.14";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "material-you-theme";
    tag = version;
    hash = "sha256-UxmVxUVCOE4ohD2l0bS/L9LZbEpX1b2Dd0q5jTNcFnc=";
  };

  npmDepsHash = "sha256-1XulvXONvEiA6oFJ0OKyJKRok3ueGmJ/7ZyBh3M6dUk=";

  installPhase = ''
    runHook preInstall
    install -Dt $out/themes themes/material_you.yaml
    runHook postInstall
  '';

  passthru.isHomeAssistantTheme = true;

  meta = {
    description = "Material Design 3 Theme for Home Assistant";
    homepage = "https://github.com/Nerwyn/material-you-theme";
    changelog = "https://github.com/Nerwyn/material-you-theme/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jpinz ];
  };
}
