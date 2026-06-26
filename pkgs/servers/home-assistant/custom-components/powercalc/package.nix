{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,

  # dependencies
  numpy,

  # tests
  home-assistant,
  pytestCheckHook,
  pytest-homeassistant-custom-component,
  pytest-freezegun,
  aioresponses,
}:

buildHomeAssistantComponent rec {
  owner = "bramstroker";
  domain = "powercalc";
  version = "1.21.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant-powercalc";
    tag = "v${version}";
    hash = "sha256-XVLemGYPuArcwek6zEZW/MS79sUWL2qbeUSTNarsZ8I=";
  };

  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
    aioresponses
    pytest-freezegun
  ]
  ++ home-assistant.getPackages "camera" home-assistant.python3Packages;

  preCheck = ''
    patchShebangs --build tests/setup.sh
    tests/setup.sh
  '';

  disabledTests = [
    # test contacts api.powercalc.nl
    "test_exception_is_raised_on_github_resource_unavailable"
  ];

  meta = {
    changelog = "https://github.com/bramstroker/homeassistant-powercalc/releases/tag/${src.tag}";
    description = "Custom Home Assistant component for virtual power sensors";
    homepage = "https://github.com/bramstroker/homeassistant-powercalc";
    maintainers = with lib.maintainers; [ CodedNil ];
    license = lib.licenses.mit;
  };
}
