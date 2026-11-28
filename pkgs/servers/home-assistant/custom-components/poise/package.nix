{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  home-assistant-frontend,
  hypothesis,
  pytest-freezer,
  pytest-homeassistant-custom-component,
  pytest9_0CheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "Ecronika";
  domain = "poise";
  version = "0.196.2";

  src = fetchFromGitHub {
    inherit owner;
    repo = "poise-thermostat";
    tag = "v${version}";
    hash = "sha256-DTHuUDxcbiKEbYlJYuy3+C/b5JHaLTaDXcb/Fwxo7F8=";
  };

  nativeCheckInputs = [
    home-assistant-frontend
    hypothesis
    pytest-freezer
    pytest-homeassistant-custom-component
    pytest9_0CheckHook
  ];

  # Upstream passes these on the command line for the glue suite.
  pytestFlags = [
    "-o"
    "asyncio_mode=auto"
    "-o"
    "asyncio_default_fixture_loop_scope=function"
  ];

  meta = {
    changelog = "https://github.com/Ecronika/poise-thermostat/releases/tag/v${version}";
    description = "Self-learning, norm-based thermostat integration";
    homepage = "https://github.com/Ecronika/poise-thermostat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nimakalantar ];
  };
}
