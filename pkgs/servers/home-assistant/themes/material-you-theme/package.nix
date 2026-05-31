{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "material-you-theme";
  version = "5.0.12";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "material-you-theme";
    tag = version;
    hash = "sha256-2wiWHU/iNIhVSJB2EqNhBi4ppsWfO9oNgfU9xU3FnrA=";
  };

  npmDepsHash = "sha256-4FNqAJlupbZT14Sy5mfCsKj7f1xK6tcpKKPrbFoSje8=";

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
