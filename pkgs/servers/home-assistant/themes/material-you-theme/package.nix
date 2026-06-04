{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "material-you-theme";
  version = "5.0.13";

  src = fetchFromGitHub {
    owner = "Nerwyn";
    repo = "material-you-theme";
    tag = version;
    hash = "sha256-HS0KeSC5YxQ1nyRqIhpRwNpfYDUkgQxJ14TEujp5rfc=";
  };

  npmDepsHash = "sha256-wFgmGet1imj9WL0WAW9JNBRwNnaTTy3ixLys3fUT4lE=";

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
