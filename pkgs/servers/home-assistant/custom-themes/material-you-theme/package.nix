{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "material-you-theme";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "material-you-theme";
    tag = version;
    hash = "sha256-xJXhvKwp/l08/ZWi3OcGPmCdsUiMjBDwrKz5OIpD2t8=";
  };

  npmDepsHash = "sha256-g133Je2Md4nKLZucSeM6TVEdaCsR2Ja1Aj2kf7JQk6w=";

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
