{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-freezegun,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "Ecronika";
  domain = "hcl_lighting";
  version = "0.9.3";

  src = fetchFromGitHub {
    inherit owner;
    repo = "ha_hcl";
    tag = "v${version}";
    hash = "sha256-u7nFyKZI/i/ChRDHU7Pa2bwuRuZffLm1vi+pkP0lYuw=";
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytest-freezegun
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  # The frontend tests drive a browser.
  disabledTestPaths = [ "tests_frontend" ];

  meta = {
    changelog = "https://github.com/Ecronika/ha_hcl/releases/tag/v${version}";
    description = "Human Centric Lighting integration";
    homepage = "https://github.com/Ecronika/ha_hcl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nimakalantar ];
  };
}
