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
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "mrk-its";
    repo = "homeassistant-blitzortung";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hed7XBBV7LID12Md0FWA0KkAjEH0RB7MQ1XJOm0W3sw=";
  };

  dependencies = [
    paho-mqtt
  ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  disabledTests = [
    # 2026.5.0 compat issue
    "test_connect_with_server_stats"
  ];

  meta = {
    description = "Custom Component for fetching lightning data from blitzortung.org";
    homepage = "https://github.com/mrk-its/homeassistant-blitzortung";
    changelog = "https://github.com/mrk-its/homeassistant-blitzortung/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
