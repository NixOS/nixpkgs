{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  home-assistant,
  pytest-asyncio,
  pytestCheckHook,
  python,
  pyprojectVersionPatchHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "vtherm-api";
  version = "0.10.0";
  pyproject = true;

  disabled = python.version != home-assistant.python3Packages.python.version;

  src = fetchFromGitHub {
    owner = "jmcollin78";
    repo = "vtherm_api";
    tag = finalAttrs.version;
    hash = "sha256-GWQILIHE8YbklwEhZz711RU4Y9GGla6z2ywJAkIyWlw=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [ setuptools ];

  nativeCheckInputs = [
    home-assistant
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = [
    # checks wrong version number
    "tests/test_package.py::test_package_exports_algorithm_plugin_api"
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
