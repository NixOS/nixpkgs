{
  lib,
  async-timeout,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  home-assistant,
  pytest-freezer,
  pytest-homeassistant,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "olen";
  domain = "plant";
  version = "2026.11.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant-plant";
    tag = "v${version}";
    hash = "sha256-vKaPvO+sNOlq+C0VNXsRrdlpCNO0pmp0FnXRs2a5WZk=";
  };

  dependencies = [
    async-timeout
  ];

  nativeCheckInputs = [
    home-assistant
    pytest-freezer
    pytest-homeassistant
    pytestCheckHook
  ];

  meta = {
    description = "Alternative Plant component of home assistant";
    homepage = "https://github.com/Olen/homeassistant-plant";
    changelog = "https://github.com/Olen/homeassistant-plant/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.gpl3Only;
  };
}
