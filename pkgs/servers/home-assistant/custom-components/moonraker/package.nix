{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  home-assistant,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-homeassistant-custom-component,

  # dependency
  moonraker-api,
}:

buildHomeAssistantComponent rec {
  owner = "marcolivierarsenault";
  domain = "moonraker";
  version = "1.13.4-unstable-2026-10-23";

  src = fetchFromGitHub {
    owner = "marcolivierarsenault";
    repo = "moonraker-home-assistant";
    rev = "84ff69970b03b53b69769ebdd0009b80f667c460";
    hash = "sha256-AMAW6ynqtCl+Bnf/4HT6RDXk72Oyr1pdI41nuxzZaAI=";
  };

  dependencies = [
    moonraker-api
  ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytest-cov-stub
    pytestCheckHook
  ]
  ++ home-assistant.getPackages "camera" home-assistant.python3Packages;

  meta = {
    changelog = "https://github.com/marcolivierarsenault/moonraker-home-assistant/releases/tag/${version}";
    description = "Custom integration for Moonraker and Klipper in Home Assistant";
    homepage = "https://github.com/marcolivierarsenault/moonraker-home-assistant";
    maintainers = with lib.maintainers; [ _9R ];
    license = lib.licenses.mit;
  };
}
