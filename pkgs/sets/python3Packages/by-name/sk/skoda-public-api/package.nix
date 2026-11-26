{
  lib,
  aiohttp,
  aresponses,
  asyncclick,
  buildPythonPackage,
  coloredlogs,
  fetchFromGitHub,
  pydantic,
  pygments,
  pytest-asyncio,
  pytestCheckHook,
  pyyaml,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "skoda-public-api";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mobility-lab-vsb";
    repo = "skoda-public-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZWptcESI/tL7dIfXty4IFek1wAccpWeLCXSksqQZdTM=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    pydantic
  ]
  # Upstream always installs the skodactl entry point.
  ++ finalAttrs.passthru.optional-dependencies.cli;

  optional-dependencies.cli = [
    asyncclick
    coloredlogs
    pygments
    pyyaml
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytestCheckHook
  ];

  # These tests call the live Škoda test API.
  disabledTestPaths = [ "tests/ci_cd_tests/test_api_client.py" ];

  pythonImportsCheck = [ "skoda_public_api.api_layer.open_api_client" ];

  meta = {
    description = "Asynchronous Python library for the Škoda public API";
    homepage = "https://github.com/mobility-lab-vsb/skoda-public-api";
    changelog = "https://github.com/mobility-lab-vsb/skoda-public-api/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
    mainProgram = "skodactl";
  };
})
