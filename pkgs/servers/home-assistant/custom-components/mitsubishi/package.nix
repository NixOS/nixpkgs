{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  pymitsubishi,
  pytest-cov-stub,
  pytestCheckHook,
  pytest-homeassistant-custom-component,
}:

buildHomeAssistantComponent rec {
  owner = "pymitsubishi";
  domain = "mitsubishi";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "pymitsubishi";
    repo = "homeassistant-mitsubishi";
    tag = "v${version}";
    hash = "sha256-qP2jLkDeiNMdTlHg0G8AryRb2v0ohGnkIoQWIWvbTbs=";
  };

  dependencies = [
    pymitsubishi
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    pytest-homeassistant-custom-component
  ];

  meta = {
    description = "Home Assistant Mitsubishi Air Conditioner Integration";
    changelog = "https://github.com/pymitsubishi/homeassistant-mitsubishi/releases/tag/v${version}";
    homepage = "https://github.com/pymitsubishi/homeassistant-mitsubishi";
    maintainers = with lib.maintainers; [ uvnikita ];
    license = lib.licenses.mit;
  };
}
