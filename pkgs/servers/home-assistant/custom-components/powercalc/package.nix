{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  fetchpatch,

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
  version = "1.20.14";

  src = fetchFromGitHub {
    inherit owner;
    repo = "homeassistant-powercalc";
    tag = "v${version}";
    hash = "sha256-Tm9h6ZHByuiM9XZz3D1TZR3ISbb16l0K1Vy8sJxI4+s=";
  };

  patches = [
    # Fix compatibility with Home-Assistant 2026.5.0
    (fetchpatch {
      url = "https://github.com/bramstroker/homeassistant-powercalc/commit/3d5e162954c21adfd9251c4d8e21872e66680454.patch";
      hash = "sha256-7InjKxT8gPiR2IvLbA4oZpkgPRJbQY39SF4YNPilp4k=";
    })
  ];

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
