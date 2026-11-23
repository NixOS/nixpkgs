{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  home-assistant,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-homeassistant,
  homeassistant,

  # dependency
  moonraker-api,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "marcolivierarsenault";
  domain = "moonraker";
  version = "1.14.0";

  src = fetchFromGitHub {
    owner = "marcolivierarsenault";
    repo = "moonraker-home-assistant";
    tag = finalAttrs.version;
    hash = "sha256-6UvTQx5pjq/99I0ptw4chQlMqQZwo0xpD2Mc0L077eI=";
  };

  dependencies = [
    moonraker-api
  ];

  nativeCheckInputs = [
    homeassistant
    pytest-homeassistant
    pytest-cov-stub
    pytestCheckHook
  ]
  ++ home-assistant.getPackages "camera" home-assistant.python3Packages;

  meta = {
    changelog = "https://github.com/marcolivierarsenault/moonraker-home-assistant/releases/tag/${finalAttrs.src.tag}";
    description = "Custom integration for Moonraker and Klipper in Home Assistant";
    homepage = "https://github.com/marcolivierarsenault/moonraker-home-assistant";
    maintainers = with lib.maintainers; [ _9R ];
    license = lib.licenses.mit;
  };
})
