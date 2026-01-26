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
  version = "1.20.3";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant-powercalc";
    tag = "v${version}";
    hash = "sha256-z66VHJ/ZzQKvx4l00XGKvTBt9o4T+hv64oCGZNDRUng=";
  };

  dependencies = [ numpy ];

  nativeCheckInputs = [
    pytest-homeassistant-custom-component
    pytestCheckHook
    aioresponses
    pytest-freezegun
  ]
  ++ home-assistant.getPackages "camera" home-assistant.python.pkgs;

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
