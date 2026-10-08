{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  stringcase,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "natekspencer";
  domain = "planta";
  version = "1.3.1";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "ha-planta";
    tag = finalAttrs.version;
    hash = "sha256-LqRBWeman+ZwkIwfSWGuAW2aCwgmLXIME0U6uz+IDVE=";
  };

  postPatch = ''
    substituteInPlace custom_components/planta/manifest.json \
      --replace-fail '"version": "0.0.0"' '"version": "${finalAttrs.version}"'
  '';

  dependencies = [ stringcase ];

  meta = {
    description = "Home Assistant integration for the Planta plant care app";
    homepage = "https://github.com/natekspencer/ha-planta";
    changelog = "https://github.com/natekspencer/ha-planta/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
