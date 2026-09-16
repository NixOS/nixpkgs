{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,

  # dependencies
  numpy,

  # tests
  aioresponses,
  gitpython,
  home-assistant,
  jsonschema,
  pytest-freezegun,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent rec {
  owner = "bramstroker";
  domain = "powercalc";
  version = "1.25.3";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant-powercalc";
    tag = "v${version}";
    hash = "sha256-Cwg0E0ppk7auAiOb++F56UqEc6cBbGi7fAdFJVn1wbI=";
  };

  dependencies = [ numpy ];

  nativeCheckInputs = [
    aioresponses
    gitpython
    jsonschema
    pytest-freezegun
    pytest-homeassistant-custom-component
    pytestCheckHook
  ]
  ++ home-assistant.getPackages "camera" home-assistant.python3Packages;

  preCheck = ''
    patchShebangs --build tests/setup.sh
    tests/setup.sh
  '';

  meta = {
    changelog = "https://github.com/bramstroker/homeassistant-powercalc/releases/tag/${src.tag}";
    description = "Custom Home Assistant component for virtual power sensors";
    homepage = "https://github.com/bramstroker/homeassistant-powercalc";
    maintainers = with lib.maintainers; [ CodedNil ];
    license = lib.licenses.mit;
  };
}
