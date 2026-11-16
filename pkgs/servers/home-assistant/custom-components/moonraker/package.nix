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

buildHomeAssistantComponent (finalAttrs: {
  owner = "marcolivierarsenault";
  domain = "moonraker";
  version = "1.14.0b0";

  src = fetchFromGitHub {
    owner = "marcolivierarsenault";
    repo = "moonraker-home-assistant";
    tag = finalAttrs.version;
    hash = "sha256-+UlrhAi5QGqXgxfxCTzvVgkuhyDbh1e5ltYbPhXGkN8=";
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
    changelog = "https://github.com/marcolivierarsenault/moonraker-home-assistant/releases/tag/${finalAttrs.src.tag}";
    description = "Custom integration for Moonraker and Klipper in Home Assistant";
    homepage = "https://github.com/marcolivierarsenault/moonraker-home-assistant";
    maintainers = with lib.maintainers; [ _9R ];
    license = lib.licenses.mit;
  };
})
