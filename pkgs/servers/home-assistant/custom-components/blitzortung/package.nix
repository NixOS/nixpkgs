{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  paho-mqtt,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "mrk-its";
  domain = "blitzortung";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "mrk-its";
    repo = "homeassistant-blitzortung";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8/KIPOmQdaaSFFrjliBBNjboPx8ewzG9/W/grBuex6s=";
  };

  dependencies = [
    paho-mqtt
  ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  meta = {
    description = "Custom Component for fetching lightning data from blitzortung.org";
    homepage = "https://github.com/mrk-its/homeassistant-blitzortung";
    changelog = "https://github.com/mrk-its/homeassistant-blitzortung/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
