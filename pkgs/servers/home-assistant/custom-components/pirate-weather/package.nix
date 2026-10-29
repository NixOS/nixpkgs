{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  nix-update-script,
  pytestCheckHook,
  pytest-homeassistant-custom-component,
  pytest-asyncio,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "Pirate-Weather";
  domain = "pirateweather";
  version = "1.9.4";

  src = fetchFromGitHub {
    inherit (finalAttrs) owner;
    repo = "pirate-weather-ha";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/KgVvITQ8Sqe/PSqWPS0nRm9oNRw9JPsoXlVczTIozg=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-homeassistant-custom-component
    pytest-asyncio
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Pirate-Weather/pirate-weather-ha/releases/tag/${finalAttrs.src.tag}";
    description = "Replacement for the default Dark Sky Home Assistant integration using Pirate Weather";
    homepage = "https://github.com/Pirate-Weather/pirate-weather-ha";
    maintainers = with lib.maintainers; [ CodedNil ];
    license = lib.licenses.asl20;
  };
})
