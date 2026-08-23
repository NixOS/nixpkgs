{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "material-you-theme";
  version = "5.0.15";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "material-you-theme";
    tag = version;
    hash = "sha256-QH6g5CArk1hO5u7WVDd0JtKUAH96OpoQd44qJtO9MEQ=";
  };

  npmDepsHash = "sha256-Cl+F9lJX9vVlwHoRkbzcRLeUAEtaRbjhcMJp7euZmTg=";

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
