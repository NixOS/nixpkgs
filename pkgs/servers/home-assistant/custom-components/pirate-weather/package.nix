{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  nix-update-script,
  pytestCheckHook,
  pytest-homeassistant-custom-component,
  pytest-asyncio,
}:

buildHomeAssistantComponent rec {
  owner = "Pirate-Weather";
  domain = "pirateweather";
  version = "1.9.5";

  src = fetchFromGitHub {
    inherit owner;
    repo = "pirate-weather-ha";
    tag = "v${version}";
    hash = "sha256-Uxt9IpqgpqTwfQX3qREzUCaxTkVxfuR3OC+9QI662Z4=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-homeassistant-custom-component
    pytest-asyncio
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Pirate-Weather/pirate-weather-ha/releases/tag/${src.tag}";
    description = "Replacement for the default Dark Sky Home Assistant integration using Pirate Weather";
    homepage = "https://github.com/Pirate-Weather/pirate-weather-ha";
    maintainers = with lib.maintainers; [ CodedNil ];
    license = lib.licenses.asl20;
  };
}
