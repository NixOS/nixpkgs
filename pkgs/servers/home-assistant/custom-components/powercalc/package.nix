{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,

  # dependencies
  numpy,

  # tests
  aioresponses,
  gitMinimal,
  gitpython,
  jsonschema,
  pytest-freezegun,
  pytest-homeassistant-custom-component,
  pytestCheckHook,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "bramstroker";
  domain = "powercalc";
  version = "1.27.0";

  src = fetchFromGitHub {
    owner = "bramstroker";
    repo = "homeassistant-powercalc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cutPSIXOPrA1PkFbgRxZWoiQxpS/nbaJvKdBKJJ+Ne0=";
  };

  dependencies = [ numpy ];

  nativeCheckInputs = [
    aioresponses
    gitMinimal
    gitpython
    jsonschema
    pytest-freezegun
    pytest-homeassistant-custom-component
    pytestCheckHook
  ];

  preCheck = ''
    patchShebangs --build tests/setup.sh
    tests/setup.sh
  '';

  meta = {
    changelog = "https://github.com/bramstroker/homeassistant-powercalc/releases/tag/${finalAttrs.src.tag}";
    description = "Custom Home Assistant component for virtual power sensors";
    homepage = "https://github.com/bramstroker/homeassistant-powercalc";
    maintainers = with lib.maintainers; [ CodedNil ];
    license = lib.licenses.mit;
  };
})
