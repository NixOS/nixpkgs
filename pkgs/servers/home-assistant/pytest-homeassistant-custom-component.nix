{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  bcrypt,
  freezegun,
  homeassistant,
  pytest-asyncio,
  pytest-socket,
  requests-mock,
  respx,
  syrupy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-homeassistant-custom-component";
  version = "0.13.297";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "MatthewFlamm";
    repo = "pytest-homeassistant-custom-component";
    tag = version;
    hash = "sha256-5s8c1OpVqQ63BNLZz0mTyqwbsIZLUmckF5yJkyNgzrw=";
  };

  build-system = [ setuptools ];

  pythonRemoveDeps = true;

  dependencies = [
    aiohttp
    bcrypt
    freezegun
    homeassistant
    pytest-asyncio
    pytest-socket
    requests-mock
    respx
    syrupy
  ];

  pythonImportsCheck = [ "pytest_homeassistant_custom_component.plugins" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # incompatible with Home Assistant 2025.12.0
    "test_entry_diagnostics"
  ];

  meta = {
    changelog = "https://github.com/MatthewFlamm/pytest-homeassistant-custom-component/blob/${src.tag}/CHANGELOG.md";
    description = "Package to automatically extract testing plugins from Home Assistant for custom component testing";
    homepage = "https://github.com/MatthewFlamm/pytest-homeassistant-custom-component";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
