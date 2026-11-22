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
  version = "2026.11.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant-plant";
    tag = "v${version}";
    hash = "sha256-jxNGNh852sW+fRkTQlRaTMMupGhgSikhWhWLMHiJR+E=";
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

  dontUsePytestXdist = true;

  meta = {
    description = "Alternative Plant component of home assistant";
    homepage = "https://github.com/Olen/homeassistant-plant";
    changelog = "https://github.com/Olen/homeassistant-plant/releases/tag/${src.tag}";
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
    license = lib.licenses.gpl3Only;
  };
}
