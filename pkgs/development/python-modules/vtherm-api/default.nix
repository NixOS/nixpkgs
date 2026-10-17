{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  home-assistant,
  pytest-asyncio,
  pytestCheckHook,
  python,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "vtherm-api";
  version = "0.5.0";
  pyproject = true;

  disabled = python.version != home-assistant.python3Packages.python.version;

  src = fetchFromGitHub {
    owner = "jmcollin78";
    repo = "vtherm_api";
    tag = finalAttrs.version;
    hash = "sha256-lhESu3rAvlbTYV2O3d3oTZiiwbzXzumqUvNNptpgsT8=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    home-assistant
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "vtherm_api" ];

  meta = {
    changelog = "https://github.com/jmcollin78/vtherm_api/releases/tag/${finalAttrs.version}";
    description = "API for Versatile Thermostat Home Assistant integrations";
    homepage = "https://github.com/jmcollin78/vtherm_api";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ geri1701 ];
  };
})
