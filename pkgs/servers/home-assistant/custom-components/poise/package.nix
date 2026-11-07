{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  hypothesis,
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

  # The glue suite in tests/integration needs pytest-homeassistant-custom-component
  # and the Home Assistant frontend wheel, so only the pure control core runs here.
  disabledTestPaths = [ "tests/integration" ];

  nativeCheckInputs = [
    hypothesis
    pytest9_0CheckHook
  ];

  meta = {
    changelog = "https://github.com/Ecronika/poise-thermostat/releases/tag/v${version}";
    description = "Self-learning, norm-based thermostat integration";
    homepage = "https://github.com/Ecronika/poise-thermostat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nimakalantar ];
  };
}
