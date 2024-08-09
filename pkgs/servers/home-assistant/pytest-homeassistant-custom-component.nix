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
  syrupy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pytest-homeassistant-custom-component";
  version = "0.13.147";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "MatthewFlamm";
    repo = "pytest-homeassistant-custom-component";
    rev = "refs/tags/${version}";
    hash = "sha256-FivgP0tKmu9QKPSVU9c/3SNduyKoSeAquHysdHSs11E=";
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
    syrupy
  ];

  pythonImportsCheck = [ "pytest_homeassistant_custom_component.plugins" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    changelog = "https://github.com/MatthewFlamm/pytest-homeassistant-custom-component/blob/${src.rev}/CHANGELOG.md";
    description = "Package to automatically extract testing plugins from Home Assistant for custom component testing";
    homepage = "https://github.com/MatthewFlamm/pytest-homeassistant-custom-component";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
