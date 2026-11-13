{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  home-assistant,
  paho-mqtt,
  pytest-homeassistant,
  pytestCheckHook,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "mrk-its";
  domain = "blitzortung";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "mrk-its";
    repo = "homeassistant-blitzortung";
    tag = "v${finalAttrs.version}";
    hash = "sha256-7xHGfLQQyBcle43FJ9cW2cmSsCph1bfRht/7T23G2tE=";
  };

  dependencies = [
    paho-mqtt
  ];

  nativeCheckInputs = [
    home-assistant
    pytest-homeassistant
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
